import Foundation

enum SettingsSection: String, CaseIterable, Identifiable {
    case exclusions
    case analyses
    case trash
    case notifications
    case appearance
    case about

    // MARK: - Properties

    var id: String { rawValue }

    var title: String {
        switch self {
        case .exclusions: return "Exclusions"
        case .analyses: return "Analyses"
        case .trash: return "Corbeille"
        case .notifications: return "Notifications"
        case .appearance: return "Apparence"
        case .about: return "À propos"
        }
    }

    var icon: String {
        switch self {
        case .exclusions: return "folder-xmark"
        case .analyses: return "magnifyingglass"
        case .trash: return "trash"
        case .notifications: return "bell"
        case .appearance: return "paintbrush"
        case .about: return "info.circle"
        }
    }
}
