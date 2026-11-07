
import SwiftUI

/// Filtre permettant de définir la taille minimale
/// des fichiers affichés dans les résultats.
struct MinimumFileSizeFilterView: View {

    /// Taille minimale en mégaoctets.
    @Binding var minimumSize: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            HStack {
                Text("Taille minimale")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                Text(
                    ByteCountFormatter.string(
                        fromByteCount: Int64(minimumSize * 1_000_000),
                        countStyle: .file
                    )
                )
                .font(.subheadline.weight(.semibold))
            }

            Text("Seuls les fichiers dont la taille atteint ce seuil seront affichés dans les résultats.")
                .font(.caption)
                .foregroundStyle(.secondary)

            Slider(
                value: $minimumSize,
                in: 10...10_000,
                step: 10
            )

            HStack {
                Text("10 Mo")
                Spacer()
                Text("10 Go")
            }
            .font(.caption2)
            .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 4)
    }
}

#Preview {
    @Previewable @State var minimumSize: Double = 500

    MinimumFileSizeFilterView(minimumSize: $minimumSize)
        .padding()
}
