import SwiftUI

/// En-tête spécialisé du tableau de bord.
///
/// Utilise PageHeader pour la présentation commune
/// et conserve le bouton d'actualisation propre au Dashboard.
struct DashboardHeaderView: View {

    /// Action permettant à la vue parente d'actualiser les informations.
    let onRefresh: () -> Void

    var body: some View {
        PageHeader(
            title: "Tableau de bord",
            subtitle: "Un aperçu rapide de l'état de votre système"
        ) {
            // L'action reste fournie par la vue parente.
            PrimaryButton(
                title: "Actualiser",
                icon: "arrow.clockwise",
                action: onRefresh
            )
        }
    }
}

// MARK: - Aperçu
#Preview {
    DashboardHeaderView(onRefresh: {})
}
