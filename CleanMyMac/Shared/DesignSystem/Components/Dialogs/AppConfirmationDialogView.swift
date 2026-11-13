import SwiftUI

/// Affiche une boîte de dialogue de confirmation personnalisée.
///
/// Présente une icône, un titre, un message et deux actions
/// permettant de confirmer ou d'annuler une opération.
struct AppConfirmationDialogView: View {

    // MARK: - Properties

    let title: String
    let message: String
    let confirmTitle: String
    let onConfirm: () -> Void
    let onCancel: () -> Void

    // MARK: - Body

    var body: some View {
        AppZStack(width: 420) {
            AppIconView(size: 64)

            AppVStack(spacing: .small, cornerRadius: .none) {
                AppText(title, style: .dialogTitle)

                AppText(message, style: .description)
                    .multilineTextAlignment(.center)
            }

            AppHStack(spacing: .extraLarge) {
                AppButton("Annuler", style: .cancel, action: onCancel)
                    .keyboardShortcut(.cancelAction)

                AppButton(
                    confirmTitle,
                    style: .destructive,
                    action: onConfirm
                )
                .keyboardShortcut(.defaultAction)
            }

        }
    }
}

// MARK: - Preview

#Preview("Demande de confirmation") {
    AppConfirmationDialogView(
        title: "Confirmer la suppression",
        message: "Les fichier sélectionnés seront déplacés vers la Corbeille.",
        confirmTitle: "Mettre à la Corbeille",
        onConfirm: {},
        onCancel: {}
    )
}
