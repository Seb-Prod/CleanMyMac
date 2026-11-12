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
struct DuplicateScannerService: Sendable {
    private let excludedFolderNames: Set<String> = [
        "node_modules",
        ".git",
        ".next",
        ".turbo",
        "DerivedData",
        "Pods",
        "Carthage",
        "dist",
        "__pycache__",
        ".venv",
        "venv",
        ".cache",
        ".pytest_cache",
        ".mypy_cache",
        ".gradle",
        ".idea",
    ]

    nonisolated init() {}

    nonisolated func groupFilesBySize(_ files: [URL]) -> [[URL]] {
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

    nonisolated func calculateHash(for fileURL: URL) throws -> String {
        let fileHandle = try FileHandle(forReadingFrom: fileURL)
        defer {
            try? fileHandle.close()
        }

        var hasher = SHA256()

        while let chunk = try fileHandle.read(upToCount: 1_048_576),
            !chunk.isEmpty
        {
            hasher.update(data: chunk)
        }

        let hash = hasher.finalize()

        return hash.map { String(format: "%02x", $0) }.joined()
    }

    nonisolated func findDuplicates(
        in files: [URL],
        progress: @Sendable (Double) -> Void
    ) throws -> [[URL]] {
        let sizeGroups = groupFilesBySize(files)
        let totalFiles = sizeGroups.reduce(0) { $0 + $1.count }

        var hashGroups: [String: [URL]] = [:]
        var processedFiles = 0

        guard totalFiles > 0 else {
            progress(1)
            return []
        }

        for group in sizeGroups {
            for fileURL in group {
                guard let hash = try? calculateHash(for: fileURL) else {
                    processedFiles += 1
                    progress(Double(processedFiles) / Double(totalFiles))
                    continue
                }

                hashGroups[hash, default: []].append(fileURL)
                processedFiles += 1
                progress(Double(processedFiles) / Double(totalFiles))
            }
        }

        return hashGroups.values.filter { $0.count > 1 }
    }

    nonisolated private func collectFiles(in folder: URL) throws -> [URL] {
        let keys: [URLResourceKey] = [
            .isRegularFileKey,
            .isSymbolicLinkKey,
            .isDirectoryKey,
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

            if values?.isSymbolicLink == true {
                enumerator.skipDescendants()
                continue
            }

            if values?.isDirectory == true,
                excludedFolderNames.contains(fileURL.lastPathComponent)
            {
                enumerator.skipDescendants()
                continue
            }

            guard values?.isRegularFile == true,
                values?.isSymbolicLink != true
            else {
                continue
            }

            files.append(fileURL)
        }

        return files
    }

    nonisolated func scan(
        folders: [URL],
        progress: @Sendable (Double) -> Void
    ) throws -> [[URL]] {
        var allFiles: [URL] = []
        var collectedPaths = Set<String>()

        for folder in folders {
            let files = try collectFiles(in: folder)

            for fileURL in files {
                if collectedPaths.insert(fileURL.path).inserted {
                    allFiles.append(fileURL)
                }
            }
        }

        return try findDuplicates(
            in: allFiles,
            progress: progress
        )
    }

}
