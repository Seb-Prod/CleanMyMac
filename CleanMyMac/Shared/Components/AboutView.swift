import SwiftUI

/// Présente les informations générales de MacCleaner Pro.
///
/// Affiche l'icône de l'application, son nom, sa version,
/// ainsi que les mentions légales.
struct AboutView: View {

    // MARK: - Properties

    @State private var copied = false

    // MARK: - Methods

    /// Copie la version de l'application dans le presse-papiers.
    private func copyAppVersion() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(
            AppInfo.appVersion,
            forType: .string
        )

        copied = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            copied = false
        }
    }

    // MARK: - Body

    var body: some View {
        AppVStack(
            alignment: .center,
            spacing: .large,
            padding: .large,
            background: .clear,
            cornerRadius: .none,
            width: 340
        ) {
            AppIconView(size: 84)

            AppVStack(alignment: .center, spacing: .small) {
                
                AppText(AppInfo.name, style: .screenTitle)

                // Bouton discret pour copier la version dans le presse-papiers
                Button(action: copyAppVersion) {
                    Text(copied ? "Version copiée !" : AppInfo.appVersion)
                        .font(.caption)
                        .foregroundStyle(copied ? .green : .secondary)
                }
                .buttonStyle(.plain)
                .help("Cliquer pour copier le numéro de version")

            }

            AppText(
                "Conçu pour simplifier votre quotidien sur Mac.",
                style: .description
            )

            Divider()
                .padding(.horizontal, 24)

            AppText(
                "© \(AppInfo.currentDate) Seb-Prod - Tous droits réservés.",
                style: .legal
            )
        }
    }
}

// MARK: - Preview

#Preview("À propos") {
    AboutView()
}
