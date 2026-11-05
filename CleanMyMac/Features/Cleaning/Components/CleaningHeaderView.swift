import SwiftUI

/// Présente le titre et la description de la fonctionnalité de nettoyage.
struct CleaningHeaderView: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Nettoyage intelligent")
                .font(.largeTitle.bold())

            Text(
                "Identifiez les fichiers temporaires "
                    + "et les fichiers de cache."
            )
            .foregroundStyle(.secondary)
        }
    }
}
