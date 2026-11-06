import SwiftUI

/// Bouton principal réutilisable de MacCleaner Pro.
struct PrimaryButton: View {

    /// Texte affiché dans le bouton.
    let title: String

    /// Icône SF Symbol facultative.
    var icon: String? = nil

    /// Action exécutée lors du clic.
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {

                if let icon {
                    Image(systemName: icon)
                }

                Text(title)
            }
            .font(.body.weight(.semibold))
            .foregroundStyle(.blue)
        }
        .buttonStyle(.glass)
        .controlSize(.large)
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(
            title: "Actualiser",
            icon: "arrow.clockwise"
        ) {}

        PrimaryButton(title: "Continuer") {}
    }
    .padding()
}


