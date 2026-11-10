import SwiftUI

/// Bouton secondaire réutilisable de MacCleaner Pro.
struct CancelButton: View {

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
            .font(.body.weight(.medium))
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
    }
}

#Preview {
    CancelButton(
        title: "Annuler",
        icon: "xmark"
    ) {}
    .padding()
}
