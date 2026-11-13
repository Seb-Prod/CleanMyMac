import SwiftUI

struct ContentView: View {

    @Environment(\.openSettings) private var openSettings

    @State private var selection: AppSection? = .dashboard
    @State private var snapshot: SystemSnapshot?

    private let systemService = SystemInfoService()

    var body: some View {

        NavigationSplitView {
            SidebarView(selection: $selection)
                .navigationSplitViewColumnWidth(250)
        } detail: {

            Group {

                switch selection ?? .largeFiles {

                case .dashboard:
                    DashboardView(
                        snapshot: snapshot,
                        onRefresh: {
                            refreshSystemInfo()
                        }
                    )

                case .cleaning:
                    JunkCleanerView()

                case .largeFiles:
                    LargeFilesView(
                        snapshot: snapshot,
                        onRefresh: {
                            refreshSystemInfo()
                        }
                    )

                case .applications:
                    PlaceholderView(
                        title: "Applications",
                        icon: "app.dashed"
                    )

                case .duplicates:
                    DuplicatesView()

                case .maintenance:
                    PlaceholderView(
                        title: "Maintenance",
                        icon: "wrench.and.screwdriver"
                    )

                case .settings:
                    SettingsView()
                }
            }
        }
        .task {
            refreshSystemInfo()
        }
        .onChange(of: selection) { _, newValue in
            if newValue == .settings {
                openSettings()
                selection = .dashboard
            }
        }
    }

    private func refreshSystemInfo() {

        snapshot = systemService.getSnapshot()
    }
}

#Preview {
    ContentView()
}
