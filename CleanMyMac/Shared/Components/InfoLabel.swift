import SwiftUI

/// Libellé d'information secondaire réutilisable.
struct InfoLabel: View {

    let title: String
    var value: String? = nil
    var icon: String? = nil

    var body: some View {
        HStack(spacing: 6) {
            if let icon {
                Image(systemName: icon)
                    .foregroundStyle(.secondary)
            }

            Text(title)
                .foregroundStyle(.secondary)

            if let value {
                Text(value)
                    .foregroundStyle(.primary)
            }
        }
        .font(.caption)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        InfoLabel(
            title: "Taille",
            value: "2,4 Go",
            icon: "externaldrive"
        )

        InfoLabel(
            title: "Dernier accès",
            value: "10 nov. 2026",
            icon: "clock"
        )

        InfoLabel(title: "Analyse terminée")
    }
    .padding()
}
