import SwiftUI

@main
struct MyApp: App {
    @State private var folderAccess = FolderAccessService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(folderAccess)
                .frame(minWidth: 1000, minHeight: 700).confirmationDialog(
                    "Autoriser l'accès aux dossiers personnels ?",
                    isPresented: $folderAccess.isAccessDialogPresented,
                    titleVisibility: .visible
                ) {
                    Button("Autoriser") {
                        folderAccess.requestAccess()
                    }

                    Button("Plus tard", role: .cancel) {}
                } message: {
                    Text(
                        "MacCleaner Pro analysera vos dossiers personnels afin d'identifier les fichiers volumineux et de vous aider à libérer de l'espace."
                    )
                }
        }
    }
}
