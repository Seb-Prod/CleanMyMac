import SwiftUI

/// Vue temporaire utilisée pour les fonctionnalités encore en développement.
struct PlaceholderView: View {
    let title: String
    let icon: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(.blue)

            Text(title)
                .font(.largeTitle.bold())

            Text("Ce module sera développé prochainement.")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    PlaceholderView(
        title: "Paramètres",
        icon: "gearshape"
    )
}
