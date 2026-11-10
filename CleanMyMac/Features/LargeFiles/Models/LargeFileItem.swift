import Foundation
import UniformTypeIdentifiers

/// Représente un fichier volumineux détecté lors d'une analyse.
struct LargeFileItem: Identifiable, Sendable {
    /// Emplacement du fichier sur le Mac.
    let url: URL
    
    /// Dossier contenant le fichier.
    var parentFolder: URL {
        url.deletingLastPathComponent()
    }

    /// Taille du fichier en octets.
    let size: Int64

    /// Date de création du fichier.
    let creationDate: Date?

    /// Date de dernière modification.
    let modificationDate: Date?

    /// Date de dernière ouverture.
    let contentAccessDate: Date?

    /// Type de contenu du fichier.
    let contentType: String?

    /// Identifiant unique basé sur son chemin.
    var id: String {
        url.path
    }

    /// Nom du fichier.
    var name: String {
        url.lastPathComponent
    }

    /// Extension du fichier en majuscules.
    var fileExtension: String {
        url.pathExtension.uppercased()
    }

    /// Icône adaptée au type de fichier.
    var systemImage: String {
        guard let contentType else {
            return "doc"
        }

        if contentType.localizedCaseInsensitiveContains("image") {
            return "photo"
        }

        if contentType.localizedCaseInsensitiveContains("video") {
            return "film"
        }

        if contentType.localizedCaseInsensitiveContains("audio") {
            return "music.note"
        }

        if contentType.localizedCaseInsensitiveContains("pdf") {
            return "doc.richtext"
        }

        if contentType.localizedCaseInsensitiveContains("archive") {
            return "archivebox"
        }

        return "doc"
    }

    /// Taille formatée pour l'affichage.
    var formattedSize: String {
        ByteCountFormatter.string(
            fromByteCount: size,
            countStyle: .file
        )
    }

    nonisolated init(url: URL, size: Int64) {
        self.url = url
        self.size = size

        let keys: Set<URLResourceKey> = [
            .creationDateKey,
            .contentModificationDateKey,
            .contentAccessDateKey,
            .contentTypeKey,
        ]

        let values = try? url.resourceValues(forKeys: keys)

        self.creationDate = values?.creationDate
        self.modificationDate = values?.contentModificationDate
        self.contentAccessDate = values?.contentAccessDate
        self.contentType = values?.contentType?.localizedDescription
    }

    /// Date de création formatée.
    var formattedCreationDate: String {
        creationDate?.formatted(date: .abbreviated, time: .omitted)
            ?? "Inconnue"
    }

    /// Date de dernière modification formatée.
    var formattedModificationDate: String {
        modificationDate?.formatted(date: .abbreviated, time: .omitted)
            ?? "Inconnue"
    }

    /// Date de dernière ouverture formatée.
    var formattedLastAccessDate: String {
        contentAccessDate?.formatted(date: .abbreviated, time: .omitted)
            ?? "Inconnue"
    }

}
