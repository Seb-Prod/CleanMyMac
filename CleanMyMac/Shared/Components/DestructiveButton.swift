import SwiftUI

/// Bouton d'action destructive réutilisable.
struct DestructiveButton: View {

    let title: String
    var icon: String? = nil
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(role: .destructive, action: action) {
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
        .disabled(isDisabled)
        .tint(.red)
    }
}

#Preview {
    VStack(spacing: 16) {
        DestructiveButton(
            title: "Mettre à la Corbeille",
            icon: "trash"
        ) {}

        DestructiveButton(
            title: "Supprimer",
            icon: "trash",
            isDisabled: true
        ) {}
    }
    .padding()
}
