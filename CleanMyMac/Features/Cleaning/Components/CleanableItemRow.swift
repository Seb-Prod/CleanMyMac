import SwiftUI

/// Composant d'interface représentant un fichier détecté comme nettoyable.
///
/// Responsabilités :
/// - Afficher le nom, la raison de détection et la taille du fichier.
/// - Indiquer si le fichier est sélectionné.
/// - Transmettre l'action de sélection à la vue parente.
///
/// Ce composant ne réalise aucune analyse et ne déplace aucun fichier.
/// La gestion de ces opérations reste dans JunkCleanerView et les services dédiés.
struct CleanableItemRow: View {

    let item: CleanableItem
    let isSelected: Bool
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {

            Button(action: onToggle) {
                Image(
                    systemName: isSelected
                        ? "checkmark.circle.fill"
                        : "circle"
                )
                .foregroundStyle(isSelected ? .blue : .secondary)
            }
            .buttonStyle(.plain)

            Image(systemName: "doc")
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .lineLimit(1)

                Text(item.reason)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(item.formattedSize)
                .font(.caption.monospacedDigit())
        }
    }
}
