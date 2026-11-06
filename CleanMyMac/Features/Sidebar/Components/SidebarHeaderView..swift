
import SwiftUI

/// Affiche l'identité visuelle de MacCleaner Pro dans le Sidebar.
struct SidebarHeaderView: View {

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "sparkles")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(
                    LinearGradient(
                        colors: [.blue, .cyan],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    in: RoundedRectangle(cornerRadius: 16)
                )

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
