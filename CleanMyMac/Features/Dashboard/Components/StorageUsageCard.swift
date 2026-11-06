import SwiftUI

/// Affiche une carte présentant l'utilisation du stockage.
///
/// Les valeurs de stockage utilisé et total sont transmises par la vue parente
/// sous forme de chaînes déjà formatées, et le taux d'utilisation sous forme
/// de ratio compris entre 0 et 1.
struct StorageUsageCard: View {

    /// Espace de stockage utilisé, déjà formaté avec son unité.
    let usedStorage: String

    /// Espace de stockage total, déjà formaté avec son unité.
    let totalStorage: String

    /// Taux d'utilisation du stockage, entre 0 et 1.
    let storageUsage: Double

    var body: some View {
        GlassCard {
            HStack(spacing: 16) {
                Image("SSDIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 52, height: 52)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Stockage")
                        .font(.title2.bold())

                    Text("\(usedStorage) utilisés sur \(totalStorage)")
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text("\(Int(storageUsage * 100)) %")
                    .font(.title3.bold())
            }

            ProgressView(value: min(max(storageUsage, 0), 1))
                .tint(.blue)
                .controlSize(.large)
        }

    }
}
