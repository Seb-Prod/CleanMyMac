import Foundation

/// Représente les différentes rubriques de navigation de MacCleaner Pro.
enum AppSection: String, CaseIterable, Identifiable {
    case dashboard
    case cleaning
    case largeFiles
    case applications
    case duplicates
    case maintenance
    case settings

    /// Identifiant unique de chaque rubrique.
    var id: String { rawValue }

    /// Titre affiché dans la barre latérale.
    var title: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .cleaning: return "Nettoyage intelligent"
        case .largeFiles: return "Gros fichiers"
        case .applications: return "Applications"
        case .duplicates: return "Doublons"
        case .maintenance: return "Maintenance"
        case .settings: return "Paramètres"
        }
    }

    /// Symbole SF Symbols associé à chaque rubrique.
    var icon: String {
        switch self {
        case .dashboard: return "square.grid.2x2"
        case .cleaning: return "sparkles"
        case .largeFiles: return "doc.text.magnifyingglass"
        case .applications: return "app.dashed"
        case .duplicates: return "doc.on.doc"
        case .maintenance: return "wrench.and.screwdriver"
        case .settings: return "gearshape"
        }
    }
}
