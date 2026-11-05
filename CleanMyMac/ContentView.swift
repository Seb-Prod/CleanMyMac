
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
                    dashboardView

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

    private var dashboardView: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 28) {

                HStack {

                    VStack(alignment: .leading, spacing: 6) {

                        Text("Bienvenue sur votre Mac")
                            .font(.largeTitle.bold())

                        Text("Voici l'état général de votre ordinateur.")
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Button {
                        refreshSystemInfo()
                    } label: {

                        Label("Actualiser", systemImage: "arrow.clockwise")
                    }
                    .buttonStyle(.bordered)
                }

                if let snapshot {

                    HStack(spacing: 16) {

                        infoCard(
                            title: "Stockage total",
                            value: snapshot.formattedTotalStorage,
                            icon: "internaldrive"
                        )

                        infoCard(
                            title: "Disponible",
                            value: snapshot.formattedAvailableStorage,
                            icon: "externaldrive"
                        )

                        infoCard(
                            title: "Mémoire installée",
                            value: snapshot.formattedMemory,
                            icon: "memorychip"
                        )
                    }

                    VStack(alignment: .leading, spacing: 16) {

                        Text("Utilisation du stockage")
                            .font(.title2.bold())

                        ProgressView(
                            value: min(
                                1,
                                max(0, snapshot.storageUsage)
                            )
                        )
                        .tint(.blue)
                        .scaleEffect(x: 1, y: 1.5, anchor: .center)

                        HStack {

                            Label(
                                snapshot.formattedUsedStorage + " utilisés",
                                systemImage: "internaldrive"
                            )

                            Spacer()

                            Text(
                                snapshot.formattedAvailableStorage +
                                " disponibles"
                            )
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .padding(24)
                    .background(
                        .regularMaterial,
                        in: RoundedRectangle(cornerRadius: 18)
                    )

                    VStack(alignment: .leading, spacing: 12) {

                        Label(
                            "Votre Mac est prêt",
                            systemImage: "checkmark.circle.fill"
                        )
                        .font(.title2.bold())
                        .foregroundStyle(.green)

                        Text(
                            "Vous pouvez maintenant explorer " +
                            "les outils de MacCleaner Pro."
                        )
                        .foregroundStyle(.secondary)
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        .regularMaterial,
                        in: RoundedRectangle(cornerRadius: 18)
                    )

                } else {

                    ProgressView("Lecture des informations système...")
                }
            }
            .padding(30)
        }
        .background(Color(nsColor: .windowBackgroundColor))
        .navigationTitle("Dashboard")
    }

    private func infoCard(
        title: String,
        value: String,
        icon: String
    ) -> some View {

        VStack(alignment: .leading, spacing: 12) {

            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)

            Text(value)
                .font(.title2.bold())
                .minimumScaleFactor(0.7)
                .lineLimit(1)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            .regularMaterial,
            in: RoundedRectangle(cornerRadius: 18)
        )
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

