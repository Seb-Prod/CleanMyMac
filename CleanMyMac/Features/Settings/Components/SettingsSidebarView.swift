import SwiftUI

struct SettingsSidebarView: View {
    @Binding var selection: SettingsSection

    // MARK: - Body

    var body: some View {
        List(SettingsSection.allCases, selection: $selection) { section in
            Label(section.title, systemImage: section.icon)
                .tag(section)
        }
        .listStyle(.sidebar)
        .navigationTitle("Réglages")
    }
}
