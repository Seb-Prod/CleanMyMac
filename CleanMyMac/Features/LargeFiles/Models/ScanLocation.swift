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

    /// Autorisation macOS permettant de retrouver l'accès au dossier.
    var bookmarkData: Data? = nil

    /// Crée un emplacement à partir d'un dossier autorisé par macOS.
    static func fromSelectedFolder(
        url: URL,
        title: String,
        icon: String
    ) throws -> ScanLocation {
        let bookmarkData = try url.bookmarkData(
            options: [.withSecurityScope],
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        )

        return ScanLocation(
            id: url.path,
            title: title,
            icon: icon,
            url: url,
            bookmarkData: bookmarkData
        )
    }
    
    /// Récupère l'URL autorisée à partir du bookmark enregistré.
    func resolveBookmark() throws -> ScanLocation {
        guard let bookmarkData else {
            throw NSError(
                domain: "ScanLocation",
                code: 1,
                userInfo: [
                    NSLocalizedDescriptionKey: "Aucun bookmark disponible."
                ]
            )
        }

        var isStale = false

        let resolvedURL = try URL(
            resolvingBookmarkData: bookmarkData,
            options: [.withSecurityScope],
            relativeTo: nil,
            bookmarkDataIsStale: &isStale
        )

        return try ScanLocation.fromSelectedFolder(
            url: resolvedURL,
            title: title,
            icon: icon
        )
    }

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
