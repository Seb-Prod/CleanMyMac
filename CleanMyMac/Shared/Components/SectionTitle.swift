import SwiftUI

/// Sous-titre réutilisable pour les sections de MacCleaner Pro.
struct SectionTitle: View {

    let subtitle: String

    var body: some View {
        Text(subtitle)
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }
}

#Preview {
    SectionTitle(
        subtitle: "Retrouvez les fichiers qui occupent le plus d'espace."
    )
    .padding()
}
