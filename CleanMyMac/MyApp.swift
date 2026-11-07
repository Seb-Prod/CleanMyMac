import SwiftUI

@main
struct MyApp: App {
    @State private var folderAccess = FolderAccessService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(folderAccess)
                .frame(minWidth: 1000, minHeight: 700)
                .sheet(isPresented: $folderAccess.isAccessDialogPresented) {
                    FolderAccessDialogView(
                        onAuthorize: {
                            folderAccess.requestAccess()
                            folderAccess.isAccessDialogPresented = false
                        },
                        onCancel: {
                            folderAccess.isAccessDialogPresented = false
                        }
                    )
                }
        }
        // Taille à l'ouverture (le frame ci-dessus reste le minimum)
        .defaultSize(width: 1100, height: 750)
        // La fenêtre ne peut pas descendre sous la taille minimale du contenu
        .windowResizability(.contentMinSize)
        // Barre de titre fondue avec la toolbar, sans titre répété
        .windowToolbarStyle(.unified(showsTitle: false))
    }
}
