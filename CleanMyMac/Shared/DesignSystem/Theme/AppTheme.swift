import SwiftUI

// MARK: - App Spacing

/// Définit les espacements standardisés de l'application.
///
/// Utilisé pour uniformiser les distances entre les éléments
/// dans les VStack, HStack et autres composants.
enum AppSpacing: String, CaseIterable, Codable, Hashable {
    case none
    case small
    case medium
    case large
    case extraLarge

    // MARK: - Values

    /// Retourne la valeur en points correspondant à l'espacement.
    var value: CGFloat {
        switch self {
        case .none:
            return 0
        case .small:
            return 8
        case .medium:
            return 16
        case .large:
            return 24
        case .extraLarge:
            return 32
        }
    }
}

// MARK: - App Padding

/// Définit les marges intérieures standardisées.
///
/// Permet de conserver des proportions cohérentes
/// entre les cartes, sections et conteneurs.
enum AppPadding: String, CaseIterable, Codable, Hashable {
    case small
    case medium
    case large
    case extraLarge

    // MARK: - Values

    /// Retourne la valeur en points correspondant à la marge intérieure.
    var value: CGFloat {
        switch self {
        case .small:
            return 8
        case .medium:
            return 16
        case .large:
            return 24
        case .extraLarge:
            return 32
        }
    }
}

// MARK: - App Background

/// Définit les différents types de fonds de l'application.
///
/// Chaque variante représente un rôle visuel précis
/// dans l'interface de MacCleaner Pro.
enum AppBackground: String, CaseIterable, Codable, Hashable {
    case primary
    case secondary
    case card
    case accent
    case clear

    // MARK: - Styles

    /// Retourne le style visuel associé à chaque type de fond.
    var shapeStyle: AnyShapeStyle {
        switch self {
        case .primary:
            return AnyShapeStyle(Color(nsColor: .windowBackgroundColor))
        case .secondary:
            return AnyShapeStyle(Color(nsColor: .underPageBackgroundColor))
        case .card:
            return AnyShapeStyle(Color(nsColor: .controlBackgroundColor))
        case .accent:
            return AnyShapeStyle(Color.accentColor)
        case .clear:
            return AnyShapeStyle(Color.clear)
        }
    }
}

// MARK: - App Corner Radius

/// Définit les rayons d'arrondi standardisés de l'application.
enum AppCornerRadius: String, CaseIterable, Codable, Hashable {
    case none
    case small
    case medium
    case large
    case extraLarge

    // MARK: - Values

    /// Retourne la valeur en points correspondant au rayon.
    var value: CGFloat {
        switch self {
        case .none:
            return 0
        case .small:
            return 6
        case .medium:
            return 10
        case .large:
            return 16
        case .extraLarge:
            return 24
        }
    }
}
