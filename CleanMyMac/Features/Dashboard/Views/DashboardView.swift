import SwiftUI

/// Présente les informations principales du tableau de bord.
struct DashboardView: View {

    /// Informations système transmises par la vue parente.
    let snapshot: SystemSnapshot?

    /// Action permettant à la vue parente d'actualiser les informations.
    let onRefresh: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            DashboardHeaderView(onRefresh: onRefresh)

            if let snapshot {
                VStack(spacing: 16) {
                    SystemInfoCard(
                        availableStorage: snapshot.formattedAvailableStorage,
                        memory: snapshot.formattedMemory
                    )

                    StorageUsageCard(
                        usedStorage: snapshot.formattedUsedStorage,
                        totalStorage: snapshot.formattedTotalStorage,
                        storageUsage: snapshot.storageUsage
                    )

                    DashboardWelcomeCard()
                }

            } else {
                AppProgressView(
                    message: "Lecture des informations système..."
                )
            }

            Spacer()
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

#Preview {
    DashboardView(
        snapshot: SystemSnapshot(
            totalStorage: 512_000_000_000,
            availableStorage: 180_000_000_000,
            usedStorage: 332_000_000_000,
            totalMemory: 16_000_000_000
        ),
        onRefresh: {}
    )
}
