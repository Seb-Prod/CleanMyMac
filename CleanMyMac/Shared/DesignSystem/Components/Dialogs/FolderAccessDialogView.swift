import SwiftUI

/// Présente la demande d'autorisation d'accès aux dossiers personnels.
///
/// Permet à l'utilisateur d'autoriser l'analyse de ses dossiers
/// ou de reporter cette décision.
struct FolderAccessDialogView: View {

    // MARK: - Properties

    let onAuthorize: () -> Void
    let onCancel: () -> Void

    // MARK: - Body

    var body: some View {
        AppZStack(width: 420) {
            AppIconView(size: 80)

            AppVStack(spacing: .small, background: .card) {

                AppText(
                    "Bienvenue dans \(AppInfo.name)",
                    style: .screenTitle
                )

                AppText(
                    "\(AppInfo.name) souhaite analyser vos dossiers personnels afin d’identifier les fichiers volumineux et de vous aider à libérer de l’espace.",
                    style: .description
                )
                .multilineTextAlignment(.center)

            }

            AppHStack(spacing: .extraLarge) {

                AppButton("Plus tard", style: .cancel, action: onCancel)
                    .keyboardShortcut(.cancelAction)

                AppButton("Autoriser", action: onAuthorize)
                    .keyboardShortcut(.defaultAction)

            }
        }
    }

}

// MARK: - Preview

#Preview("Demande d'accès au répertoire") {
    FolderAccessDialogView(onAuthorize: {}, onCancel: {})
}
