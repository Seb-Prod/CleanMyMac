
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

            VStack(alignment: .leading, spacing: 6) {

                Text("Nettoyage intelligent")
                    .font(.largeTitle.bold())

                Text(
                    "Identifiez les fichiers temporaires " +
                    "et les fichiers de cache."
                )
                .foregroundStyle(.secondary)
            }

            HStack {

                Label(
                    folder?.lastPathComponent ??
                    "Aucun dossier sélectionné",
                    systemImage: "folder"
                )
                .lineLimit(1)

                Spacer()

                Button("Choisir un dossier") {
                    showFolderPicker = true
                }
                .buttonStyle(.bordered)
            }

            Button {

                startScan()

            } label: {

                Label(
                    isScanning ? "Analyse en cours..." : "Lancer l'analyse",
                    systemImage: "sparkles"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(folder == nil || isScanning)

            if isScanning {
                ProgressView()
            }

            if !items.isEmpty {

                HStack {

                    VStack(alignment: .leading, spacing: 4) {

                        Text("Espace potentiellement récupérable")
                            .font(.headline)

                        Text(
                            ByteCountFormatter.string(
                                fromByteCount: totalSize,
                                countStyle: .file
                            )
                        )
                        .font(.largeTitle.bold())
                        .foregroundStyle(.blue)
                    }

                    Spacer()

                    Image(systemName: "externaldrive.badge.checkmark")
                        .font(.system(size: 35))
                        .foregroundStyle(.blue)
                }
                .padding(20)
                .background(
                    .regularMaterial,
                    in: RoundedRectangle(cornerRadius: 16)
                )
            }

            if !items.isEmpty {

                HStack {

                    Text("\(selectedIDs.count) sélectionné(s)")

                    Spacer()

                    Button("Tout sélectionner") {
                        selectedIDs = Set(items.map(\.id))
                    }
                    .buttonStyle(.borderless)

                    Button("Tout désélectionner") {
                        selectedIDs.removeAll()
                    }
                    .buttonStyle(.borderless)
                }
                .font(.caption)
            }

            List {

                ForEach(items) { item in

                    HStack(spacing: 12) {

                        Button {

                            toggle(item)

                        } label: {

                            Image(
                                systemName: selectedIDs.contains(item.id)
                                ? "checkmark.circle.fill"
                                : "circle"
                            )
                            .foregroundStyle(
                                selectedIDs.contains(item.id)
                                ? .blue
                                : .secondary
                            )
                        }
                        .buttonStyle(.plain)

                        Image(systemName: "doc")
                            .foregroundStyle(.secondary)

                        VStack(alignment: .leading, spacing: 4) {

                            Text(item.name)
                                .lineLimit(1)

                            Text(item.reason)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Text(item.formattedSize)
                            .font(.caption.monospacedDigit())
                    }
                }
            }
            .listStyle(.inset)

            if !items.isEmpty {

                Button {

                    showConfirmation = true

                } label: {

                    Label(
                        "Mettre la sélection à la Corbeille",
                        systemImage: "trash"
                    )
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .disabled(selectedIDs.isEmpty || isScanning)
            }

            if !statusMessage.isEmpty {
                Text(statusMessage)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if let errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
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

            Button("Annuler", role: .cancel) { }

        } message: {

            Text(
                "Les fichiers sélectionnés seront déplacés " +
                "vers la Corbeille macOS. " +
                "Taille sélectionnée : " +
                ByteCountFormatter.string(
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

                    statusMessage = results.isEmpty
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
