import SwiftUI

struct DuplicatesView: View {

    // MARK: - Properties

    @Environment(FolderAccessService.self) private var folderAccess

    @State private var isScanning = false
    @State private var isScanWaitingForAuthorization = false
    @State private var duplicateGroups: [[URL]] = []
    @State private var hasScanned = false
    @State private var scanProgress: Double = 0

    // MARK: - Methods

    /// Lance l'analyse des répertoires autorisés à la recherche de doublons.
    ///
    /// Si l'accès aux dossiers n'est pas encore autorisé, demande
    /// l'autorisation avant de lancer l'analyse.
    ///
    /// Tous les répertoires sont transmis au scanner en une seule opération
    /// afin de détecter les doublons entre différents emplacements.
    private func startScan() {
        guard folderAccess.isAuthorized else {
            isScanWaitingForAuthorization = true
            folderAccess.isAccessDialogPresented = true
            return
        }

        guard !isScanning else { return }

        isScanning = true
        scanProgress = 0
        hasScanned = false
        duplicateGroups = []

        let folders = folderAccess.personalFolders

        Task {
            defer {
                isScanning = false
            }

            do {
                let results = try await Task.detached(priority: .utility) {
                    try DuplicateScannerService().scan(folders: folders) { progress in
                        Task { @MainActor in
                            scanProgress = progress
                        }
                    }
                }.value
                
                duplicateGroups = results
                hasScanned = true

            } catch {
                print(
                    "Erreur lors de la recherche des doublons : \(error.localizedDescription)"
                )
            }
        }
    }

    // MARK: - View

    var body: some View {

        VStack(alignment: .leading, spacing: 20) {
            PageHeader(
                title: "Fichiers en double",
                subtitle:
                    "Identifiez et supprimez les fichiers en double sur votre Mac."
            ) {
                PrimaryButton(
                    title: "Analyser",
                    icon: "magnifyingglass",
                    action: startScan
                ).disabled(isScanning)
            }

            DuplicatesContentView(
                isScanning: isScanning,
                hasScanned: hasScanned,
                duplicateGroups: duplicateGroups,
                scanProgress: scanProgress
            )
        }
        .padding()
        .onChange(of: folderAccess.isAuthorized) { _, isAuthorized in
            guard isAuthorized, isScanWaitingForAuthorization else {
                return
            }

            isScanWaitingForAuthorization = false
            startScan()
        }
    }

}

#Preview {
    DuplicatesView()
}
