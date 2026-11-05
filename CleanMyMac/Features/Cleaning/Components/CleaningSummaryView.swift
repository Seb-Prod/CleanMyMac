import SwiftUI

/// Présente le résumé de l'espace potentiellement récupérable.
///
/// Responsabilités :
/// - Afficher le volume total des fichiers détectés.
/// - Mettre en évidence l'espace potentiellement récupérable.
///
/// Ce composant ne réalise aucune analyse et ne modifie aucun fichier.
///
struct CleaningSummaryView: View {

    /// Taille totale des fichiers détectés, exprimée en octets.
    let totalSize: Int64

    private var formattedSize: String {
        ByteCountFormatter.string(
            fromByteCount: totalSize,
            countStyle: .file
        )
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Espace potentiellement récupérable")
                    .font(.headline)

                Text(formattedSize)
                    .font(.largeTitle.bold())
                    .foregroundStyle(.blue)
            }

            Spacer()

            Image(systemName: "externaldrive.badge.checkmark")
                .font(.system(size: 35))
                .foregroundStyle(.blue)
        }
        .padding(20)
        .background(
            .regularMaterial,
            in: RoundedRectangle(cornerRadius: 16)
        )
    }
}
