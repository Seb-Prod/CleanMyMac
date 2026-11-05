import SwiftUI

/// Affiche le bouton permettant de lancer l'analyse des fichiers.
struct CleaningScanButton: View {

    /// Indique si une analyse est actuellement en cours.
    let isScanning: Bool

    /// Indique si le bouton doit être désactivé.
    let isDisabled: Bool

    /// Action exécutée lorsque l'utilisateur lance l'analyse.
    let onScan: () -> Void
    
    var body: some View {
        Button {
            onScan()
        } label: {
            Label(
                isScanning ? "Analyse en cours..." : "Lancer l'analyse",
                systemImage: "sparkles"
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .disabled(isDisabled)
    }
}
