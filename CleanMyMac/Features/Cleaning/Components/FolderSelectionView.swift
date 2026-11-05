import SwiftUI

/// Affiche le dossier sélectionné et permet d'en choisir un autre.
struct FolderSelectionView: View {

    /// Nom du dossier sélectionné, ou nil si aucun dossier n'est choisi.
    let folderName: String?

    /// Action déclenchée lorsque l'utilisateur demande à choisir un dossier.
    let onChooseFolder: () -> Void
    
    var body: some View {
        HStack {
            Label(
                folderName ?? "Aucun dossier sélectionné",
                systemImage: "folder"
            )
            .lineLimit(1)

            Spacer()

            Button("Choisir un dossier") {
                onChooseFolder()
            }
            .buttonStyle(.bordered)
        }
    }
}
