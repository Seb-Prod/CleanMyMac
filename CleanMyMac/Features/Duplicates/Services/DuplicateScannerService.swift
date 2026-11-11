import CryptoKit
import Foundation

/// Analyse plusieurs répertoires pour détecter les fichiers en double.
///
/// Les fichiers de tous les répertoires sont rassemblés avant la comparaison.
/// Cela permet de détecter les doublons même lorsqu'ils se trouvent
/// dans des emplacements différents.
///
/// - Parameter folders: Les répertoires à analyser.
/// - Returns: Les groupes de fichiers ayant un contenu identique.
/// - Throws: Une erreur si l'accès à l'un des répertoires échoue
///   ou si le calcul d'une empreinte échoue.
struct DuplicateScannerService {

    /// Regroupe les fichiers selon leur taille.
    ///
    /// Les groupes contenant un seul fichier sont ignorés, car ils ne peuvent
    /// pas contenir de doublons.
    ///
    /// - Parameter files: Les fichiers à regrouper.
    /// - Returns: Les groupes contenant au moins deux fichiers de même taille.
    func groupFilesBySize(_ files: [URL]) -> [[URL]] {
        var groups: [Int64: [URL]] = [:]

        for fileURL in files {
            guard
                let values = try? fileURL.resourceValues(forKeys: [.fileSizeKey]
                ),
                let fileSize = values.fileSize
            else {
                continue
            }

            groups[Int64(fileSize), default: []].append(fileURL)
        }

        return groups.values.filter { $0.count > 1 }
    }

    
    /// Calcule l'empreinte cryptographique SHA-256 d'un fichier.
    ///
    /// Le fichier est lu progressivement par blocs de 1 Mo afin de limiter
    /// la consommation de mémoire, même pour les fichiers volumineux.
    ///
    /// - Parameter fileURL: L'URL du fichier à analyser.
    /// - Returns: L'empreinte SHA-256 sous forme de chaîne hexadécimale.
    /// - Throws: Une erreur si le fichier ne peut pas être lu.
    func calculateHash(for fileURL: URL) throws -> String {
        let fileHandle = try FileHandle(forReadingFrom: fileURL)
        defer {
            try? fileHandle.close()
        }

        var hasher = SHA256()

        while let chunk = try fileHandle.read(upToCount: 1_048_576),
              !chunk.isEmpty {
            hasher.update(data: chunk)
        }

        let hash = hasher.finalize()

        return hash.map { String(format: "%02x", $0) }.joined()
    }


    /// Identifie les fichiers ayant un contenu strictement identique.
    ///
    /// Les fichiers sont d'abord regroupés par taille, puis comparés
    /// à l'aide de leurs empreintes SHA-256.
    ///
    /// - Parameter files: Les fichiers à comparer.
    /// - Returns: Les groupes contenant des fichiers identiques.
    /// - Throws: Une erreur si le calcul d'une empreinte échoue.
    func findDuplicates(in files: [URL]) throws -> [[URL]] {
        let sizeGroups = groupFilesBySize(files)

        var hashGroups: [String: [URL]] = [:]

        for group in sizeGroups {
            for fileURL in group {
                let hash = try calculateHash(for: fileURL)
                hashGroups[hash, default: []].append(fileURL)
            }
        }

        return hashGroups.values.filter { $0.count > 1 }
    }

    /// Récupère les fichiers réguliers d'un répertoire et de ses sous-répertoires.
    ///
    /// Les dossiers et les liens symboliques sont ignorés.
    ///
    /// - Parameter folder: Le répertoire à parcourir.
    /// - Returns: La liste des fichiers trouvés.
    /// - Throws: Une erreur si le répertoire ne peut pas être parcouru.
    private func collectFiles(in folder: URL) throws -> [URL] {
        let keys: [URLResourceKey] = [
            .isRegularFileKey,
            .isSymbolicLinkKey,
        ]

        guard
            let enumerator = FileManager.default.enumerator(
                at: folder,
                includingPropertiesForKeys: keys,
                options: [.skipsPackageDescendants]
            )
        else {
            throw NSError(
                domain: "DuplicateScannerService",
                code: 1,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Impossible d'accéder au dossier \(folder.lastPathComponent)."
                ]
            )
        }

        var files: [URL] = []

        for case let fileURL as URL in enumerator {
            let values = try? fileURL.resourceValues(forKeys: Set(keys))

            guard values?.isRegularFile == true,
                values?.isSymbolicLink != true
            else {
                continue
            }

            files.append(fileURL)
        }

        return files
    }

    /// Analyse un dossier pour trouver des fichiers en double.
    ///
    /// Cette méthode parcourt le contenu du dossier spécifié, filtre les fichiers réguliers
    /// (en ignorant les liens symboliques) et lance la recherche de doublons.
    ///
    /// - Parameter folder: L'URL du dossier à analyser.
    /// - Returns: Un tableau d'URL représentant les fichiers en double trouvés.
    /// - Throws: Une erreur `NSError` si l'accès au dossier est impossible.
    func scan(folders: [URL]) throws -> [[URL]] {
        var allFiles: [URL] = []

        for folder in folders {
            let files = try collectFiles(in: folder)
            allFiles.append(contentsOf: files)
        }

        return try findDuplicates(in: allFiles)
    }

}
