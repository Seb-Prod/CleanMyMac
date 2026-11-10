import SwiftUI

/// En-tête générique réutilisable dans les différentes pages.
///
/// Responsabilités :
/// - Afficher le titre de la page.
/// - Afficher une description.
/// - Proposer une zone d'action facultative à droite.
///
/// Ce composant ne gère aucun état métier.
/// Les actions sont fournies par la vue parente.
struct PageHeader<Actions: View>: View {

    /// Titre principal de la page.
    let title: String

    /// Description affichée sous le titre.
    let subtitle: String

    /// Contenu facultatif affiché à droite du titre.
    @ViewBuilder let actions: Actions

    var body: some View {
        HStack(alignment: .center, spacing: 16) {

            // Titre et description de la page.
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title2.weight(.semibold))

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Zone réservée aux boutons ou autres actions.
            actions
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Aperçu

#Preview {
    PageHeader(
        title: "Gros fichiers",
        subtitle: "Identifiez les fichiers volumineux sur votre Mac."
    ) {
        EmptyView()
    }
    .padding()
}
