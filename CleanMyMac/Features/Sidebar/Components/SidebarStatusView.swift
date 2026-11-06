import SwiftUI

/// Affiche l'état actuel de MacCleaner Pro dans le Sidebar.
struct SidebarStatusView: View {

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(.green)
                .frame(width: 8, height: 8)

            Text("Prêt à analyser")
                .font(.caption)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
    }
}

#Preview {
    SidebarStatusView()
        .frame(width: 220)
        .padding()
}
