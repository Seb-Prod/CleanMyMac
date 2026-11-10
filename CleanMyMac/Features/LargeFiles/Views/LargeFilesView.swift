import SwiftUI

/// Vue principale du module Gros fichiers.
///
/// Responsabilités :
/// - Afficher l'en-tête du module.
/// - Proposer les différents emplacements à analyser.
/// - Permettre de régler la taille minimale des fichiers.
/// - Afficher les résultats de l'analyse.
///
/// La gestion des états et des actions utilisateur reste centralisée
/// dans cette vue. Les composants enfants seront principalement
/// chargés de présenter les informations.
struct LargeFilesView: View {

    // MARK: - État de l'analyse

    let snapshot: SystemSnapshot?
    let onRefresh: () -> Void

    @Environment(FolderAccessService.self) private var folderAccess

    @State private var isScanWaitingForAuthorization = false

    /// Taille minimale des fichiers recherchés, exprimée en mégaoctets.
    /// La valeur initiale est fixée à 500 Mo.
    @State private var minimumSize: Double = 500

    /// Indique si une analyse est actuellement en cours.
    @State private var isScanning = false

    /// État de l'analyse pour chaque répertoire.
    @State private var scanStatuses: [String: LargeFilesScanStatus] = [:]

    /// Liste des fichiers volumineux détectés.
    @State private var results: [LargeFileItem] = []

    /// Emplacement dont la liste des fichiers doit être affichée.
    @State private var selectedLocation: ScanLocation?

    /// Identifiants des fichiers sélectionnés.
    @State private var selectedFileIDs: Set<String> = []

    /// Taille des fichiers suivis dans la Corbeille.
    @State private var managedTrashSize: Int64 = 0

    /// Contrôle la confirmation du vidage de la Corbeille.
    @State private var isEmptyTrashConfirmationPresented = false

    /// Retourne les fichiers trouvés dans un emplacement donné.
    private func files(for location: ScanLocation) -> [LargeFileItem] {
        let threshold = Int64(minimumSize * 1_000_000)

        return results.filter { file in
            file.url.path.hasPrefix(location.url.path + "/")
                && file.size >= threshold
        }
    }

    /// Taille totale des fichiers correspondant au filtre actuel.
    private var recoverableSize: Int64 {
        let threshold = Int64(minimumSize * 1_000_000)

        return
            results
            .filter { $0.size >= threshold }
            .reduce(Int64(0)) { $0 + $1.size }
    }

    /// Lance l'analyse de tous les répertoires personnels.
    private func startScan() {
        guard folderAccess.isAuthorized else {
            isScanWaitingForAuthorization = true
            folderAccess.isAccessDialogPresented = true
            return
        }

        guard !isScanning else { return }

        isScanning = true
        results = []

        let locations = folderAccess.personalFolders.map { url in
            ScanLocation(
                id: url.path,
                title: url.lastPathComponent,
                icon: "folder",
                url: url
            )
        }

        scanStatuses = Dictionary(
            uniqueKeysWithValues: locations.map {
                ($0.id, .notScanned)
            }
        )

        Task {
            defer {
                isScanning = false
            }

            for location in locations {
                scanStatuses[location.id] = .scanning

                let threshold: Int64 = 10_000_000

                do {
                    let locationResults = try await Task.detached(
                        priority: .utility
                    ) {
                        try LargeFilesScannerService().scan(
                            folder: location.url,
                            minimumSize: threshold
                        )
                    }.value

                    results.append(contentsOf: locationResults)
                    scanStatuses[location.id] = .completed

                } catch {
                    scanStatuses[location.id] = .failed
                    print(
                        "Erreur pour \(location.title) : \(error.localizedDescription)"
                    )
                }
            }
        }
    }

    /// Déplace les fichiers sélectionnés vers la Corbeille.
    private func moveSelectedFilesToTrash() {
        let selectedFiles = results.filter {
            selectedFileIDs.contains($0.id)
        }

        var successfullyTrashedIDs: Set<String> = []

        for file in selectedFiles {
            do {
                try TrashService().moveToTrash(file.url)
                successfullyTrashedIDs.insert(file.id)
            } catch {
                print(
                    "Erreur lors du déplacement de \(file.name) : \(error.localizedDescription)"
                )
            }
        }

        results.removeAll {
            successfullyTrashedIDs.contains($0.id)
        }

        selectedFileIDs.subtract(successfullyTrashedIDs)
        managedTrashSize = TrashService().getManagedTrashSize()
        onRefresh()
    }

    /// Vide uniquement les fichiers suivis par MacCleaner Pro.
    private func emptyManagedTrash() {
        do {
            try TrashService().emptyManagedTrash()
        } catch {
            print("Erreur lors du vidage de la Corbeille : \(error.localizedDescription)")
        }

        managedTrashSize = TrashService().getManagedTrashSize()
        onRefresh()
    }
    // MARK: - Interface

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // En-tête du module.
            LargeFilesHeaderView(
                onScan: {
                    startScan()
                },
                isScanning: isScanning
            )

            // Sélection de l'emplacement à analyser.
            ScrollView {
                ScanLocationSelectionView(
                    onOpenLocation: { location in
                        selectedLocation = location
                    },
                    statisticsForLocation: { location in
                        let locationFiles = files(for: location)

                        return (
                            fileCount: locationFiles.count,
                            totalSize: locationFiles.reduce(0) { $0 + $1.size }
                        )
                    },
                    statusForLocation: { location in
                        scanStatuses[location.id] ?? .notScanned
                    },
                    locations: folderAccess.personalFolders.map { url in
                        ScanLocation(
                            id: url.path,
                            title: url.lastPathComponent,
                            icon: "folder",
                            url: url
                        )
                    }
                )
            }

            MinimumFileSizeFilterView(minimumSize: $minimumSize)

            StorageSummaryView(
                availableStorage: snapshot?.availableStorage ?? 0,
                recoverableSize: recoverableSize,
                managedTrashSize: managedTrashSize,
                onEmptyTrash: {
                    isEmptyTrashConfirmationPresented = true
                }

            )
        }
        .padding(30)
        .task {
            managedTrashSize = TrashService().getManagedTrashSize()
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        ).onChange(of: folderAccess.isAuthorized) { _, isAuthorized in
            guard isAuthorized, isScanWaitingForAuthorization else { return }

            isScanWaitingForAuthorization = false
            startScan()
        }.sheet(item: $selectedLocation) { location in
            LargeFilesListView(
                location: location,
                files: files(for: location),
                selectedFileIDs: $selectedFileIDs,
                onRequestDelete: {
                    moveSelectedFilesToTrash()
                    selectedLocation = nil
                }
            )
        }.overlay {
            if isEmptyTrashConfirmationPresented {
                AppConfirmationDialogView(
                    title: "Vider la Corbeille ?",
                    message: "Les fichiers placés dans la Corbeille par MacCleaner Pro seront définitivement supprimés. Cette action est irréversible.",
                    confirmTitle: "Vider définitivement",
                    onConfirm: {
                        isEmptyTrashConfirmationPresented = false
                        emptyManagedTrash()
                    },
                    onCancel: {
                        isEmptyTrashConfirmationPresented = false
                    }
                )
            }
        }
    }

}
