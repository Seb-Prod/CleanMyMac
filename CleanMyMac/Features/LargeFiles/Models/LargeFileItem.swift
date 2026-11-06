import Foundation

/// Représente un fichier volumineux détecté lors d'une analyse.
struct LargeFileItem: Identifiable, Sendable {
    /// Emplacement du fichier sur le Mac.
    let url: URL

    /// Taille du fichier en octets.
    let size: Int64

    /// Identifiant unique basé sur son chemin.
    var id: String {
        url.path
    }

    /// Nom du fichier.
    var name: String {
        url.lastPathComponent
    }

    /// Taille formatée pour l'affichage.
    var formattedSize: String {
        ByteCountFormatter.string(
            fromByteCount: size,
            countStyle: .file
        )
    }
}
