import SwiftUI

/// Affiche le nombre de fichiers sélectionnés et les actions de sélection.
struct CleaningSelectionBar: View {
    
    /// Nombre de fichiers sélectionnés
    let selectedCount: Int

    /// Action pour tout sélectionner
    let onSelectAll: () -> Void

    /// Action pour tout désélectionner
    let onDeselectAll: () -> Void

    var body: some View {
        HStack{
            Text("\(selectedCount) sélectionné(s)")

            Spacer()

            Button("Tout sélectionner"){
                onSelectAll()
            }
            .buttonStyle(.borderless)

            Button("Tout désélectionner"){
                onDeselectAll()
            }
            .buttonStyle(.borderless)
        }
        .font(.caption)
    }
}
