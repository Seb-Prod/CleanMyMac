import SwiftUI

/// Affiche l'en-tête du tableau de bord avec son titre,
/// sa description et le bouton d'actualisation.
///
/// L'action d'actualisation est transmise par la vue parente
/// via une closure `onRefresh`.
struct DashboardHeaderView: View {

    /// Action permettant à la vue parente d'actualiser les informations.
    let onRefresh: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Tableau de bord")
                    .font(.largeTitle.bold())

                Text(
                    "Un aperçu rapide de l'état de votre système"
                )
                .foregroundStyle(.secondary)
            }

            Spacer()

            PrimaryButton(title: "Actualiser",icon: "arrow.clockwise", action:onRefresh)
        }

    }
}

#Preview {
    DashboardHeaderView(onRefresh: {})
}
