import SwiftUI

/// Affiche deux cartes présentant les principales informations système.
///
/// Les valeurs de stockage disponible et de mémoire installée
/// sont transmises par la vue parente sous forme de chaînes déjà formatées.
struct SystemInfoCard: View {

    /// Espace de stockage disponible, déjà formaté avec son unité.
    let availableStorage: String

    /// Quantité de mémoire vive installée, déjà formatée avec son unité.
    let memory: String

    var body: some View {
        HStack(spacing: 16) {
            infoCard(
                title: "Espace disponible",
                value: availableStorage,
                icon: "SSDIcon"
            )

            infoCard(
                title: "Mémoire installée",
                value: memory,
                icon: "RamIcon"
            )
        }
    }

    
}

/// Construit une carte d'information système à partir d'un titre,
/// d'une valeur formatée et d'une icône.
private func infoCard(
    title: String,
    value: String,
    icon: String
) -> some View {
    GlassCard {
        VStack(alignment: .leading, spacing: 12) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 68, height: 68)

            Text(value)
                .font(.title.bold())
                .lineLimit(1)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    SystemInfoCard(
        availableStorage: "180",
        memory: "16"
    )
    .padding()
}
