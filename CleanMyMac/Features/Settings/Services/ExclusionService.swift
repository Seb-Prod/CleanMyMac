import Foundation

struct ExclusionService {
    private let storageKey = "MacCleanerPro.excludedFolders"

    func loadExclusions() -> [ExcludedFolder] {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
            let folders = try? JSONDecoder().decode(
                [ExcludedFolder].self,
                from: data
            )
        else {
            return []
        }

        return folders
    }

    func isExcluded(
        _ url: URL,
        for analysis: AnalysisType
    ) -> Bool {
        let folders = loadExclusions()

        return folders.contains { folder in
            folder.excludedAnalyses.contains(analysis)
                && url.path.hasPrefix(
                    folder.url.path.hasSuffix("/")
                        ? folder.url.path
                        : folder.url.path + "/"
                )
        }
    }

    func saveExclusions(_ folders: [ExcludedFolder]) {
        guard let data = try? JSONEncoder().encode(folders) else {
            return
        }

        UserDefaults.standard.set(data, forKey: storageKey)
    }

    func addExclusion(_ folder: ExcludedFolder) {
        var folders = loadExclusions()

        guard !folders.contains(where: { $0.url == folder.url }) else {
            return
        }

        folders.append(folder)
        saveExclusions(folders)
    }

    func removeExclusion(_ folder: ExcludedFolder) {
        var folders = loadExclusions()

        folders.removeAll { $0.id == folder.id }

        saveExclusions(folders)
    }

    func updateExclusion(_ folder: ExcludedFolder) {
        var folders = loadExclusions()

        guard let index = folders.firstIndex(where: { $0.id == folder.id })
        else {
            return
        }

        folders[index] = folder
        saveExclusions(folders)
    }
}
