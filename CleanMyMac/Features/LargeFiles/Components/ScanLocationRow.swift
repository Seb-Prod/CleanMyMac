import SwiftUI

/// Ligne représentant un emplacement analysable.
///
/// La gestion des états et des actions reste dans LargeFilesView.
struct ScanLocationRow: View {

    /// Emplacement représenté par cette ligne.
    let location: ScanLocation

    /// État actuel de l'analyse du répertoire.
    var status: LargeFilesScanStatus = .notScanned

    /// Paramètres conservés temporairement pour maintenir
    /// la compatibilité avec la vue parente.
    let fileCount: Int
    let totalSize: Int64

    /// Action appelée lorsque l'utilisateur demande les détails.
    let onOpen: () -> Void

    /// Contrôle l'apparence de la ligne au survol.
    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 12) {

            // Icône et nom du répertoire.
            Label(location.title, systemImage: location.icon)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Statistiques des fichiers trouvés.
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(fileCount) fichiers")
                    .font(.subheadline)

                Text(
                    ByteCountFormatter.string(
                        fromByteCount: totalSize,
                        countStyle: .file
                    )
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Group {
                switch status {

                case .notScanned:
                    Image(systemName: "info.circle")
                        .foregroundStyle(.tertiary)

                case .scanning:
                    ProgressView()
                        .controlSize(.small)

                case .completed:
                    Button(action: onOpen) {
                        Image(systemName: "info.circle")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                    .help("Afficher les fichiers")

                case .failed:
                    Image(systemName: "exclamationmark.circle")
                        .foregroundStyle(.orange)
                        .help("L'analyse a échoué")
                }
            }
            .frame(width: 24)
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    isHovered
                        ? Color.primary.opacity(0.04)
                        : Color.clear
                )
        }
    }
}
