import Foundation

/// Représente un emplacement pouvant être analysé par MacCleaner Pro.
///
/// Responsabilités :
/// - Identifier un emplacement de recherche.
/// - Fournir son nom et son icône pour l'interface.
/// - Conserver son URL pour permettre au service d'analyse de le parcourir.
///
/// Ce modèle ne réalise aucune analyse et ne gère aucune autorisation.
struct ScanLocation: Identifiable, Sendable, Codable {

    /// Identifiant unique de l'emplacement.
    let id: String

    /// Nom affiché dans l'interface.
    let title: String

    /// Symbole SF Symbols associé à l'emplacement.
    let icon: String

    /// URL du dossier à analyser.
    let url: URL

    /// Retourne les principaux dossiers personnels de l'utilisateur.
    static var personalLocations: [ScanLocation] {

        // FileManager permet de retrouver les emplacements standards
        // du compte utilisateur sans construire manuellement leurs chemins.
        let fileManager = FileManager.default

        // Association entre chaque dossier macOS, son nom et son icône.
        let directories:
            [(
                directory: FileManager.SearchPathDirectory, title: String,
                icon: String
            )] = [
                (.desktopDirectory, "Bureau", "menubar.dock.rectangle"),
                (.documentDirectory, "Documents", "doc.text"),
                (.downloadsDirectory, "Téléchargements", "arrow.down.circle"),
                (.picturesDirectory, "Images", "photo"),
                (.moviesDirectory, "Vidéos", "film"),
                (.musicDirectory, "Musique", "music.note"),
            ]

        // Conversion des dossiers standards en objets ScanLocation.
        // compactMap ignore les emplacements que macOS ne parvient pas à retrouver.
        return directories.compactMap { item in

            guard
                let url = fileManager.urls(
                    for: item.directory,
                    in: .userDomainMask
                ).first
            else {
                return nil
            }

            return ScanLocation(
                id: "\(item.directory.rawValue)",
                title: item.title,
                icon: item.icon,
                url: url
            )
        }
    }
}
