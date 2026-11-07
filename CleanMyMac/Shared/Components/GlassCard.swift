import SwiftUI

/// Carte réutilisable avec un effet Liquid Glass.
///
/// - Verre `.regular` (la variante `.clear` disparaît sur un fond pastel).
/// - Teinte optionnelle pour donner une couleur d'accent à chaque carte.
/// - Liseré clair + ombre douce pour détacher la carte du fond.
struct GlassCard<Content: View>: View {

    // ── 🎛️ Configuration ────────────────────────────────────

    /// Teinte du verre. `nil` = verre neutre.
    var tint: Color? = nil

    /// Rayon des coins, partagé par le verre, le liseré et l'ombre.
    var cornerRadius: CGFloat = 24

    /// Contenu affiché à l'intérieur de la carte.
    @ViewBuilder let content: Content

    // ── 🧩 Rendu ────────────────────────────────────────────

    /// Forme commune pour garder verre et liseré parfaitement alignés.
    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }

    /// Variante de verre : teintée si une couleur est fournie.
    private var glass: Glass {
        if let tint { return .regular.tint(tint.opacity(0.18)) }
        return .regular
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content
        }
        .padding(24)                                  // plus aéré que 20
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(glass, in: shape)
        // Liseré clair : donne un vrai bord à la carte
        .overlay {
            shape.strokeBorder(.white.opacity(0.55), lineWidth: 1)
        }
        // Ombre douce : crée la profondeur entre fond et carte
        .shadow(color: .black.opacity(0.08), radius: 20, y: 8)
    }
}

// ── Aperçu ──────────────────────────────────────────────────

#Preview {
    ZStack {
        AppBackground()

        // Le conteneur harmonise le rendu des cartes en verre
        GlassEffectContainer(spacing: 16) {
            VStack(spacing: 16) {
                GlassCard(tint: .blue) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Stockage", systemImage: "internaldrive")
                            .font(.headline)

                        Text("332 Go utilisés")
                            .font(.title2.bold())

                        Text("Sur 512 Go disponibles")
                            .foregroundStyle(.secondary)
                    }
                }

                GlassCard(tint: .green) {
                    Label("Votre Mac est en bonne santé", systemImage: "checkmark.circle")
                        .font(.headline)
                        .foregroundStyle(.green)
                }
            }
        }
        .padding()
    }
}
