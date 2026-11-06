import SwiftUI

struct ContentView: View {

    @State private var selection: AppSection? = .largeFiles

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
                    LargeFilesView()

                case .applications:
                    PlaceholderView(
                        title: "Applications",
                        icon: "app.dashed"
                    )

                case .duplicates:
                    PlaceholderView(
                        title: "Doublons",
                        icon: "doc.on.doc"
                    )

                case .maintenance:
                    PlaceholderView(
                        title: "Maintenance",
                        icon: "wrench.and.screwdriver"
                    )

                case .settings:
                    PlaceholderView(
                        title: "Paramètres",
                        icon: "gearshape"
                    )
                }
            }
        }
        .task {
            refreshSystemInfo()
        }
    }

    private func refreshSystemInfo() {

        snapshot = systemService.getSnapshot()
    }
}

#Preview {
    ContentView()
}
