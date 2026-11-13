import SwiftUI

/// Conteneur de superposition réutilisable pour les dialogues.
///
/// Ajoute automatiquement un fond assombri et place
/// le contenu au premier plan de l'interface.
struct AppZStack<Content: View>: View {

    // MARK: - Properties

    let width: CGFloat?
    let content: Content

    // MARK: - Initialization

    init(
        width: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.width = width
        self.content = content()
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Color.black.opacity(0.25)
                .ignoresSafeArea()

            AppVStack(
                padding: .large,
                background: .card,
                cornerRadius: .large,
                width: width
            ) {
                content
            }
            .shadow(radius: 20)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview

#Preview("App ZStack") {
    AppZStack(
        width: 420
    ) {

        AppIconView(size: 80)

        AppText("Exemple de dialogue", style: .dialogTitle)

        AppText(
            "Contenu de démonstration.",
            style: .description
        )

        AppHStack {
            AppButton("Annuler", style: .cancel) {}
            AppButton("Confirmer", style: .destructive) {}
        }
    }

}
