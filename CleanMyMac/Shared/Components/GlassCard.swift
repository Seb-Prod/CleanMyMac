import SwiftUI

/// Carte réutilisable avec un effet Liquid Glass.
struct GlassCard<Content: View>: View {
    /// Contenu affiché à l'intérieur de la carte.
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(
            .clear,
            in: RoundedRectangle(cornerRadius: 20)
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                Label("Stockage", systemImage: "internaldrive")
                    .font(.headline)

                Text("332 Go utilisés")
                    .font(.title2.bold())

                Text("Sur 512 Go disponibles")
                    .foregroundStyle(.secondary)
            }
        }

        GlassCard {
            Label("Votre Mac est en bonne santé", systemImage: "checkmark.circle")
        }
    }
    .padding()
}
