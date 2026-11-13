import SwiftUI

struct SettingsView: View {
    // MARK: - Body
    var body: some View {
        TabView {
            ExclusionsView()
                .tabItem {
                    Label("Exclusions", systemImage: "folder.badge.minus")
                }

            PlaceholderView(
                title: "Analyses",
                icon: "magnifyingglass"
            )
            .tabItem {
                Label("Analyses", systemImage: "magnifyingglass")
            }

            PlaceholderView(
                title: "Corbeille",
                icon: "trash"
            )
            .tabItem {
                Label("Corbeille", systemImage: "trash")
            }

            PlaceholderView(
                title: "Notifications",
                icon: "bell"
            )
            .tabItem {
                Label("Notifications", systemImage: "bell")
            }

            PlaceholderView(
                title: "Apparence",
                icon: "paintbrush"
            )
            .tabItem {
                Label("Apparence", systemImage: "paintbrush")
            }

            PlaceholderView(
                title: "À propos",
                icon: "info.circle"
            )
            .tabItem {
                Label("À propos", systemImage: "info.circle")
            }
        }
        .padding()
        .frame(width: 650, height: 450)
    }
}
