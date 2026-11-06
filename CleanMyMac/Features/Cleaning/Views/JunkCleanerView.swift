import SwiftUI
import UniformTypeIdentifiers

struct JunkCleanerView: View {

    @State private var folder: URL?

    @State private var items: [CleanableItem] = []

    @State private var selectedIDs: Set<String> = []

    @State private var isScanning = false

    @State private var showFolderPicker = false

    @State private var showConfirmation = false

    @State private var errorMessage: String?

    @State private var statusMessage = ""

    private let scanner = JunkScannerService()

    private var selectedItems: [CleanableItem] {
        items.filter {
            selectedIDs.contains($0.id)
        }
    }

    private var selectedSize: Int64 {
        selectedItems.reduce(0) {
            $0 + $1.size
        }
    }

    private var totalSize: Int64 {
        items.reduce(0) {
            $0 + $1.size
        }
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 22) {

            /// Présente le titre et la description de la fonctionnalité de nettoyage
            CleaningHeaderView()

            /// Affiche le dossier sélectionné et permet d'en choisir un autre
            FolderSelectionView(
                folderName: folder?.lastPathComponent
            ) {
                showFolderPicker = true
            }

            /// Bouton permettant de lancer l'analyse des fichiers
            CleaningScanButton(
                isScanning: isScanning,
                isDisabled: folder == nil || isScanning
            ) {
                startScan()
            }

            if isScanning {
                ProgressView()
            }

            if !items.isEmpty {
                /// Résumé de l'espace potentiellement récupérable
                CleaningSummaryView(totalSize: totalSize)

                /// Affichage du nombre de fichiers sélectionnés et des actions de sélection
                CleaningSelectionBar(
                    selectedCount: selectedIDs.count,
                    onSelectAll: {
                        selectedIDs = Set(items.map(\.id))
                    },
                    onDeselectAll: {
                        selectedIDs.removeAll()
                    }
                )
            }

            /// Liste des fichiers détectés comme nettoyable
            List {
                ForEach(items) { item in
                    CleanableItemRow(
                        item: item,
                        isSelected: selectedIDs.contains(item.id)
                    ) {
                        toggle(item)
                    }
                }

            }
            .listStyle(.inset)

            if !items.isEmpty {
                /// Bouton permettant de lancer le nettoyage des fichiers sélectionnés
                CleaningActionButton(
                    isDisabled: selectedIDs.isEmpty || isScanning
                ) {
                    showConfirmation = true
                }
            }

            /// Affichage des messages d'information et des éventuelles erreurs du nettoyage
            CleaningFeedbackView(
                statusMessage: statusMessage,
                errorMessage: errorMessage
            )
        }
        .padding(28)
        .fileImporter(
            isPresented: $showFolderPicker,
            allowedContentTypes: [.folder],
            allowsMultipleSelection: false
        ) { result in

            switch result {

            case .success(let urls):

                guard let url = urls.first else { return }

                if let oldFolder = folder {
                    oldFolder.stopAccessingSecurityScopedResource()
                }

                guard url.startAccessingSecurityScopedResource() else {
                    folder = nil
                    errorMessage = "Accès au dossier refusé."
                    return
                }

                folder = url
                items = []
                selectedIDs = []
                errorMessage = nil
                statusMessage = "Dossier sélectionné."

            case .failure(let error):

                errorMessage = error.localizedDescription
            }
        }
        .confirmationDialog(
            "Confirmer le nettoyage",
            isPresented: $showConfirmation,
            titleVisibility: .visible
        ) {

            Button(
                "Mettre \(selectedIDs.count) fichier(s) à la Corbeille",
                role: .destructive
            ) {
                cleanSelectedItems()
            }

            Button("Annuler", role: .cancel) {}

        } message: {

            Text(
                "Les fichiers sélectionnés seront déplacés "
                    + "vers la Corbeille macOS. " + "Taille sélectionnée : "
                    + ByteCountFormatter.string(
                        fromByteCount: selectedSize,
                        countStyle: .file
                    )
            )
        }
        .onDisappear {

            folder?.stopAccessingSecurityScopedResource()
            folder = nil
        }
    }

    private func toggle(_ item: CleanableItem) {

        if selectedIDs.contains(item.id) {
            selectedIDs.remove(item.id)
        } else {
            selectedIDs.insert(item.id)
        }
    }

    private func startScan() {

        guard let folder else { return }

        isScanning = true
        items = []
        selectedIDs = []
        errorMessage = nil
        statusMessage = ""

        Task.detached(priority: .userInitiated) {

            do {

                let results = try scanner.scan(folder: folder)

                await MainActor.run {

                    items = results
                    isScanning = false

                    statusMessage =
                        results.isEmpty
                        ? "Aucun fichier correspondant trouvé."
                        : "\(results.count) fichier(s) détecté(s)."
                }

            } catch {

                await MainActor.run {

                    isScanning = false
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func cleanSelectedItems() {

        let toClean = selectedItems

        var moved = 0
        var failed = 0

        for item in toClean {

            do {

                try scanner.moveToTrash(item)
                moved += 1

            } catch {

                failed += 1
            }
        }

        let movedURLs = Set(
            toClean
                .filter {
                    !FileManager.default.fileExists(
                        atPath: $0.url.path
                    )
                }
                .map(\.url.path)
        )

        items.removeAll {
            movedURLs.contains($0.url.path)
        }

        selectedIDs.subtract(movedURLs)

        statusMessage = "\(moved) fichier(s) déplacé(s) vers la Corbeille."

        if failed > 0 {
            errorMessage = "\(failed) fichier(s) n'ont pas pu être déplacés."
        }
    }
}

#Preview {
    JunkCleanerView()
}
