import Foundation

struct TrashService {

    private let storageKey = "MacCleanerPro.managedTrashItems"

    /// Emplacements des fichiers placés dans la Corbeille par l'application.
    private var trackedURLs: [URL] {
        let paths = UserDefaults.standard.stringArray(forKey: storageKey) ?? []
        return paths.map { URL(fileURLWithPath: $0) }
    }

    /// Déplace un fichier dans la Corbeille et mémorise son nouvel emplacement.
    func moveToTrash(_ url: URL) throws {
        var resultingURL: NSURL?

        try FileManager.default.trashItem(
            at: url,
            resultingItemURL: &resultingURL
        )

        if let resultingURL,
            let path = resultingURL.path
        {
            var paths =
                UserDefaults.standard.stringArray(forKey: storageKey) ?? []
            paths.append(path)
            UserDefaults.standard.set(paths, forKey: storageKey)
        }
    }

    /// Calcule uniquement la taille des fichiers suivis par MacCleaner Pro.
    func getManagedTrashSize() -> Int64 {
        var totalSize: Int64 = 0
        var existingPaths: [String] = []

        for url in trackedURLs {
            guard let values = try? url.resourceValues(
                forKeys: [.isRegularFileKey, .fileSizeKey]
            ),
            values.isRegularFile == true,
            let size = values.fileSize else {
                continue
            }

            totalSize += Int64(size)
            existingPaths.append(url.path)
        }

        UserDefaults.standard.set(existingPaths, forKey: storageKey)

        return totalSize
    }
    
    /// Supprime uniquement les fichiers suivis par MacCleaner Pro.
    func emptyManagedTrash() throws {
        var remainingPaths: [String] = []
        var encounteredError: Error?

        for url in trackedURLs {
            do {
                if FileManager.default.fileExists(atPath: url.path) {
                    try FileManager.default.removeItem(at: url)
                }
            } catch {
                remainingPaths.append(url.path)
                encounteredError = error
            }
        }

        UserDefaults.standard.set(remainingPaths, forKey: storageKey)

        if let encounteredError {
            throw encounteredError
        }
    }
}
