import SwiftUI

/// Affiche deux cartes présentant les principales informations système.
///
/// Les valeurs de stockage disponible et de mémoire installée
/// sont transmises par la vue parente sous forme de chaînes déjà formatées.
///
/// - Chaque carte a sa teinte : bleu pour le stockage, indigo pour la mémoire.
/// - Les deux cartes sont dans un `GlassEffectContainer` pour un rendu homogène.
struct SystemInfoCard: View {


    /// Espace de stockage disponible, déjà formaté avec son unité.
    let availableStorage: String

    /// Quantité de mémoire vive installée, déjà formatée avec son unité.
    let memory: String


    var body: some View {
        GlassEffectContainer(spacing: 16) {
            HStack(spacing: 16) {
                infoCard(
                    title: "Espace disponible",
                    value: availableStorage,
                    icon: "SSDIcon",
                    tint: .white
                )

                infoCard(
                    title: "Mémoire installée",
                    value: memory,
                    icon: "RamIcon",
                    tint: .white
                )
            }
        }
    }



    /// Construit une carte d'information système à partir d'un titre,
    /// d'une valeur formatée, d'une icône et d'une teinte d'accent.
    private func infoCard(
        title: String,
        value: String,
        icon: String,
        tint: Color
    ) -> some View {
        GlassCard(tint: tint) {
            VStack(alignment: .leading, spacing: 12) {
                // Icône décorative : le titre porte déjà le sens
                Image(decorative: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 68, height: 68)

                // Valeur mise en avant : plus grande, arrondie, chiffres de largeur fixe
                Text(value)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)            // évite la coupure si la valeur est longue
                    .contentTransition(.numericText())  // animation fluide au rafraîchissement

                Text(title)
                    .font(.subheadline)                 // .caption était trop discret
                    .foregroundStyle(.secondary)
            }
        }
        // VoiceOver lit « Espace disponible, 22,38 GB » en un seul bloc
        .accessibilityElement(children: .combine)
    }
}

// ── Aperçu ──────────────────────────────────────────────────

#Preview {
    ZStack {
        AppBackground()

        SystemInfoCard(
            availableStorage: "180",
            memory: "16"
        )
        .padding()
    }
}
