import SwiftUI

/// Affiche le bouton permettant de lancer le nettoyage des fichiers sélectionnés.
struct CleaningActionButton: View {

    /// Indique si le bouton doit être désactivé.
    let isDisabled: Bool

    /// Action exécutée lorsque l'utilisateur demande le nettoyage.
    let onClean: () -> Void

    var body: some View {
    Button {
        onClean()
    } label: {
        Label(
            "Mettre la sélection à la Corbeille",
            systemImage: "trash"
        )
        .frame(maxWidth: .infinity)
    }
    .buttonStyle(.borderedProminent)
    .tint(.blue)
    .disabled(isDisabled)
}
}