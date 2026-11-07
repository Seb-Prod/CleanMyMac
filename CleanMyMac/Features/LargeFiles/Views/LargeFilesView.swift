import AppKit
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

    /// Répertoires sélectionnés et autorisés par l'utilisateur.
    @State private var selectedLocations: [ScanLocation] = []

    /// Clé utilisée pour conserver les dossiers autorisés.
    private let locationsStorageKey = "authorizedScanLocations"

    /// Retourne les fichiers trouvés dans un emplacement donné.
    private func files(for location: ScanLocation) -> [LargeFileItem] {
        let threshold = Int64(minimumSize * 1_000_000)

        return results.filter { file in
            file.url.path.hasPrefix(location.url.path + "/")
                && file.size >= threshold
        }
    }

    /// Enregistre les emplacements autorisés.
    private func saveLocations() {
        do {
            let data = try JSONEncoder().encode(selectedLocations)
            UserDefaults.standard.set(data, forKey: locationsStorageKey)
        } catch {
            print("Erreur de sauvegarde : \(error.localizedDescription)")
        }
    }

    /// Restaure les emplacements autorisés précédemment enregistrés.
    private func loadLocations() {
        guard
            let data = UserDefaults.standard.data(
                forKey: locationsStorageKey
            )
        else { return }

        do {
            let savedLocations = try JSONDecoder().decode(
                [ScanLocation].self,
                from: data
            )

            selectedLocations = try savedLocations.map {
                try $0.resolveBookmark()
            }

            saveLocations()

        } catch {
            print("Erreur de restauration : \(error.localizedDescription)")
        }
    }

    /// Ouvre le sélecteur natif de dossiers macOS.
    private func selectFolders() {
        let panel = NSOpenPanel()
        panel.title = "Autoriser l'accès à votre dossier personnel"
        panel.message =
            "MacCleaner Pro analysera automatiquement les dossiers personnels que vous autorisez."
        panel.prompt = "Autoriser l'accès"
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.canCreateDirectories = false
        panel.directoryURL = FileManager.default.homeDirectoryForCurrentUser

        guard panel.runModal() == .OK else { return }

        do {
            let newLocations = try panel.urls.map { url in
                try ScanLocation.fromSelectedFolder(
                    url: url,
                    title: url.lastPathComponent,
                    icon: "folder"
                )
            }

            selectedLocations = newLocations

            saveLocations()

        } catch {
            print(
                "Impossible de créer les autorisations : \(error.localizedDescription)"
            )
        }
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

                guard location.url.startAccessingSecurityScopedResource() else {
                    scanStatuses[location.id] = .failed
                    print("Impossible d'accéder à \(location.title)")
                    continue
                }

                defer {
                    location.url.stopAccessingSecurityScopedResource()
                }

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

    // MARK: - Interface

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // En-tête du module.
            LargeFilesHeaderView(
                onScan: {
                    startScan()
                },
                isScanning: isScanning,
                onSelectFolders: { selectFolders() }
            )

            // Sélection de l'emplacement à analyser.
            ScrollView {
                ScanLocationSelectionView(
                    onOpenLocation: { location in
                        print("Emplacement sélectionné : \(location.title)")
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

        }
        .padding(30)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .onAppear {
            loadLocations()
        }
        .onChange(of: folderAccess.isAuthorized) { _, isAuthorized in
            guard isAuthorized, isScanWaitingForAuthorization else { return }

            isScanWaitingForAuthorization = false
            startScan()
        }

    }

}

#Preview {
    LargeFilesView()
}
