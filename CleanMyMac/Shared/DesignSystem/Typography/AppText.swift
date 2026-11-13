import SwiftUI

// MARK: - Text Styles

/// Définit les styles typographiques utilisés dans MacCleaner Pro.
///
/// Chaque style représente un rôle précis dans l'interface,
/// afin de conserver une identité visuelle cohérente.
enum AppTextStyle: String, CaseIterable {
    case screenTitle  // Grand titre de page
    case dialogTitle  // Titre de fenêtre ou de dialogue
    case sectionHeader  // Titre de section ou de carte
    case body  // Texte courant principal
    case description  // Sous-titre ou texte explicatif
    case caption  // Information complémentaire
    case legal  // Copyright et mentions légales
}

// MARK: - App Text

/// Composant de texte réutilisable.
///
/// Centralise les polices et les couleurs sémantiques
/// afin d'uniformiser la typographie de l'application.
struct AppText: View {

    // MARK: - Properties

    let text: String
    var style: AppTextStyle = .body
    var color: Color? = nil

    // MARK: - Initialization

    init(
        _ text: String,
        style: AppTextStyle = .body,
        color: Color? = nil
    ) {
        self.text = text
        self.style = style
        self.color = color
    }

    // MARK: - Body

    var body: some View {
        Text(text)
            .font(fontForStyle)
            .foregroundStyle(resolvedStyle)
    }

    // MARK: - Typography

    /// Retourne la police correspondant au style demandé.
    private var fontForStyle: Font {
        switch style {
        case .screenTitle:
            return .title.bold()
        case .dialogTitle:
            return .title2.bold()
        case .sectionHeader:
            return .headline
        case .body:
            return .body
        case .description:
            return .subheadline
        case .caption:
            return .caption
        case .legal:
            return .caption2
        }
    }

    // MARK: - Colors

    /// Retourne la couleur personnalisée ou la couleur
    /// sémantique associée au style.
    private var resolvedStyle: AnyShapeStyle {
        if let color {
            return AnyShapeStyle(color)
        }

        switch style {
        case .screenTitle, .dialogTitle, .sectionHeader, .body:
            return AnyShapeStyle(.primary)

        case .description, .caption:
            return AnyShapeStyle(.secondary)

        case .legal:
            return AnyShapeStyle(.tertiary)
        }
    }
}

// MARK: - Preview

#Preview("App Text Styles") {
    VStack(alignment: .leading, spacing: 16) {
        AppText("Titre de page", style: .screenTitle)
        AppText("Titre de dialogue", style: .dialogTitle)
        AppText("Titre de section", style: .sectionHeader)
        AppText("Texte courant principal", style: .body)
        AppText("Description explicative", style: .description)
        AppText("Information complémentaire", style: .caption)
        AppText("© 2026 MacCleaner Pro", style: .legal)

        Divider()

        AppText("Texte avec couleur personnalisée", color: .blue)
    }
    .padding(24)
    .frame(width: 400, alignment: .leading)
}
