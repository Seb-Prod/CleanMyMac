import SwiftUI

// MARK: - Button Styles

/// Définit les variantes visuelles des boutons de l'application.
enum AppButtonStyle {
    case primary  // Action principale
    case secondary  // Action secondaire
    case destructive  // Suppression, vidage
    case cancel  // Annuler, fermer
    case toolbar  // Actions dans les barres d'outils
    case text  // Action secondaires discrètes
}

// MARK: - App Button

/// Composant de bouton réutilisable.
///
/// Centralise l'apparence et le comportement des boutons.
struct AppButton: View {

    // MARK: - Properties

    let title: String
    let style: AppButtonStyle
    let icon: String?
    let isDisabled: Bool
    let action: () -> Void

    // MARK: - Initialization

    init(
        _ title: String,
        style: AppButtonStyle = .primary,
        icon: String? = nil,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.icon = icon
        self.isDisabled = isDisabled
        self.action = action
    }

    // MARK: - Body

    var body: some View {
        buttonAppearance
    }

    // MARK: - Button Appearance

    /// Retourne l'apparence SwiftUI correspondant à la variante demandée.
    @ViewBuilder
    private var buttonAppearance: some View {
        switch style {
        case .primary:
            buttonContent
                .buttonStyle(.borderedProminent)

        case .secondary, .destructive, .cancel:
            buttonContent
                .buttonStyle(.bordered)

        case .toolbar, .text:
            buttonContent
                .buttonStyle(.plain)
        }
    }

    /// Construit le contenu visuel du bouton.
    private var buttonContent: some View {
        Button(role: buttonRole, action: action) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                }

                Text(title)
            }
            .font(.body.weight(.semibold))
        }
        .disabled(isDisabled)
        .controlSize(.large)
        .tint(buttonTint)
    }

    /// Retourne la couleur du bouton correspondant au style demandé.
    private var buttonTint: Color {
        switch style {
        case .primary, .text:
            return .blue
        case .secondary, .cancel, .toolbar:
            return .secondary
        case .destructive:
            return .red

        }
    }

    /// Retourne le rôle sémantique du bouton.
    private var buttonRole: ButtonRole? {
        switch style {
        case .destructive:
            return .destructive

        case .primary, .secondary, .cancel, .toolbar, .text:
            return nil
        }
    }
}

// MARK: - Preview

#Preview("App Button Styles") {
    VStack(alignment: .leading, spacing: 16) {
        AppButton("Continuer", style: .primary, icon: "arrow.right") {}
        AppButton("Options", style: .secondary, icon: "gearshape") {}
        AppButton("Supprimer", style: .destructive, icon: "trash") {}
        AppButton("Annuler", style: .cancel) {}
        AppButton("Actualiser", style: .toolbar, icon: "arrow.clockwise") {}
        AppButton("En savoir plus", style: .text) {}
        AppButton("Désactivé", style: .primary, isDisabled: true) {}
    }
    .padding(24)
    .frame(width: 400)
}
