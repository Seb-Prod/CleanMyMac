import SwiftUI

/// Élément de navigation réutilisable du Sidebar.
struct SidebarNavigationItem: View {

    /// Nom de la rubrique.
    let title: String

    /// Symbole SF Symbols associé à la rubrique.
    let icon: String

    /// Indique si cette rubrique est sélectionnée.
    let isSelected: Bool

    /// Action exécutée lors du clic.
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.body.weight(isSelected ? .semibold : .regular))
                .foregroundStyle(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                    }
                }
        }
        .buttonStyle(.plain)
        .contentShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    VStack(spacing: 8) {
        SidebarNavigationItem(
            title: "Dashboard",
            icon: "square.grid.2x2",
            isSelected: true,
            action: {}
        )

        SidebarNavigationItem(
            title: "Nettoyage intelligent",
            icon: "sparkles",
            isSelected: false,
            action: {}
        )
    }
    .padding()
    .frame(width: 240)
}
