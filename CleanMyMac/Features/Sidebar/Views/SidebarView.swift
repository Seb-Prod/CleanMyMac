import SwiftUI

/// Vue principale de la barre latérale de MacCleaner Pro.
struct SidebarView: View {

    /// Rubrique actuellement sélectionnée.
    @Binding var selection: AppSection?

    var body: some View {
        VStack(spacing: 0) {

            // Identité de l'application
            SidebarHeaderView()

            Divider()
                .padding(.horizontal, 12)

            // Navigation
            VStack(spacing: 6) {
                ForEach(AppSection.allCases) { section in
                    SidebarNavigationItem(
                        title: section.title,
                        icon: section.icon,
                        isSelected: selection == section
                    ) {
                        selection = section
                    }
                }
            }
            .padding(12)

            Spacer()

            // État de l'application
            SidebarStatusView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

#Preview {
    @Previewable @State var selection: AppSection? = .dashboard

    SidebarView(selection: $selection)
        .frame(width: 250, height: 600)
}
