import SwiftUI

/// Vue d'état générique affichée quand une page n'a pas (encore) de contenu à montrer.
///
/// - Rôle : centrer une icône SF Symbols, un titre et, si fourni, un message explicatif
///   dans tout l'espace disponible.
/// - Cas d'usage :
///   - **Fonctionnalité en développement** : écran temporaire (ex. « Paramètres »).
///   - **État vide en attente d'une action** : tant que l'utilisateur n'a pas lancé
///     d'analyse (ex. recherche de fichiers en double), cette vue est affichée à la
///     place des résultats, avec un message qui l'invite à démarrer.
/// - États visuels : avec ou sans message (le texte secondaire n'est rendu que s'il existe).
/// - Comportement dynamique : la vue n'a pas d'état interne ; c'est à la vue parente
///   de la remplacer par le contenu réel dès que les données sont disponibles.
struct PlaceholderView: View {

    // MARK: - Propriétés

    /// Titre principal affiché sous l'icône (ex. « Aucune analyse lancée »).
    let title: String

    /// Message secondaire optionnel, par exemple une invitation à lancer une analyse.
    /// `var` permet de le rendre optionnel dans l'init synthétisé.
    var message: String? = nil

    /// Nom du symbole SF Symbols affiché au-dessus du titre.
    let icon: String

    // MARK: - Corps

    var body: some View {
        VStack(spacing: 16) {
            // ── Icône ──
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(.blue)

            // ── Titre ──
            Text(title)
                .font(.largeTitle.bold())

            // ── Message optionnel ──
            if let message {
                Text(message)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Aperçus

#Preview("Fonctionnalité en développement") {
    PlaceholderView(
        title: "Paramètres",
        icon: "gearshape"
    )
}

#Preview("État vide en attente d'une action") {
    PlaceholderView(
        title: "Aucune analyse lancée",
        message: "Lancez une analyse pour détecter les fichiers en double.",
        icon: "doc.on.doc",
        
    )
}
