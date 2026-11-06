import SwiftUI

/// Affiche une carte de bienvenue sur le tableau de bord.
///
/// Présente un message indiquant que le Mac est prêt
/// et invite l'utilisateur à explorer les outils de MacCleaner Pro.
struct DashboardWelcomeCard: View {

    var body: some View {
        GlassCard {
            Label(
                "Votre Mac est prêt",
                systemImage: "sparkles"
            )
            .font(.title2.bold())
            .foregroundStyle(.blue)

            Text(
                "Vous pouvez maintenant explorer les outils de MacCleaner Pro."
            )
            .foregroundStyle(.secondary)
        }

    }
}
