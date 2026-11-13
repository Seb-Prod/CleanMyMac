
import SwiftUI

/// Affiche l'identité visuelle de MacCleaner Pro dans le Sidebar.
struct SidebarHeaderView: View {

    var body: some View {
        VStack(spacing: 10) {
            AppIconView(size: 128)

            Text("MacCleaner Pro")
                .font(.title3.bold())

            Text("Votre Mac, plus léger")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}

#Preview {
    SidebarHeaderView()
        .frame(width: 200)
        .padding()
}
