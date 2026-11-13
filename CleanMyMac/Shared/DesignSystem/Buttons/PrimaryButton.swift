import SwiftUI

/// Bouton principal réutilisable de MacCleaner Pro.
struct PrimaryButton: View {

    let title: String
    var icon: String? = nil
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
        }
        .buttonStyle(.borderedProminent)
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
