import SwiftUI

enum AppSection: String, CaseIterable, Identifiable {

    case dashboard
    case cleaning
    case largeFiles
    case applications
    case duplicates
    case maintenance
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .cleaning: return "Nettoyage intelligent"
        case .largeFiles: return "Gros fichiers"
        case .applications: return "Applications"
        case .duplicates: return "Doublons"
        case .maintenance: return "Maintenance"
        case .settings: return "Paramètres"
        }
    }

    var icon: String {
        switch self {
        case .dashboard: return "square.grid.2x2"
        case .cleaning: return "sparkles"
        case .largeFiles: return "doc.text.magnifyingglass"
        case .applications: return "app.dashed"
        case .duplicates: return "doc.on.doc"
        case .maintenance: return "wrench.and.screwdriver"
        case .settings: return "gearshape"
        }
    }
}

struct ContentView: View {

    @State private var selection: AppSection? = .dashboard

    @State private var snapshot: SystemSnapshot?

    private let systemService = SystemInfoService()

    var body: some View {

        NavigationSplitView {

            List(selection: $selection) {

                Section("MACCLEANER PRO") {

                    ForEach(AppSection.allCases) { section in

                        Label(
                            section.title,
                            systemImage: section.icon
                        )
                        .tag(section)
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("MacCleaner Pro")

        } detail: {

            Group {

                switch selection ?? .dashboard {

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
                    placeholderView(
                        "Gros fichiers",
                        icon: "doc.text.magnifyingglass"
                    )

                case .applications:
                    placeholderView(
                        "Applications",
                        icon: "app.dashed"
                    )

                case .duplicates:
                    placeholderView(
                        "Doublons",
                        icon: "doc.on.doc"
                    )

                case .maintenance:
                    placeholderView(
                        "Maintenance",
                        icon: "wrench.and.screwdriver"
                    )

                case .settings:
                    placeholderView(
                        "Paramètres",
                        icon: "gearshape"
                    )
                }
            }
        }
        .task {
            refreshSystemInfo()
        }
    }

    

    

    private func placeholderView(
        _ title: String,
        icon: String
    ) -> some View {

        VStack(spacing: 16) {

            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(.blue)

            Text(title)
                .font(.largeTitle.bold())

            Text("Ce module sera développé prochainement.")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(title)
    }

    private func refreshSystemInfo() {

        snapshot = systemService.getSnapshot()
    }
}

#Preview {
    ContentView()
}
