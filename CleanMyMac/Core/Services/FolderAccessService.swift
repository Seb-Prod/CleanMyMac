import Foundation
import Observation

@Observable
final class FolderAccessService {
    private(set) var isAuthorized = false
    
    private(set) var hasResponded = false
    
    var isAccessDialogPresented = true

    private(set) var personalFolders: [URL] = []

    func requestAccess() {
        let homeDirectory = FileManager.default.homeDirectoryForCurrentUser

        do {
            let contents = try FileManager.default.contentsOfDirectory(
                at: homeDirectory,
                includingPropertiesForKeys: [.isDirectoryKey, .isHiddenKey],
                options: [.skipsHiddenFiles]
            )

            personalFolders = contents.filter { url in
                let values = try? url.resourceValues(
                    forKeys: [.isDirectoryKey, .isHiddenKey]
                )

                return values?.isDirectory == true &&
                       values?.isHidden != true
            }
        } catch {
            print("Erreur de détection : \(error.localizedDescription)")
        }

        isAuthorized = true
        hasResponded = true
        
        print("Dossiers personnels détectés : \(personalFolders.count)")

        for folder in personalFolders {
            print("📁 \(folder.lastPathComponent) — \(folder.path)")
        }
    }
}
