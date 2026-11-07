import AppKit
import SwiftUI

struct FolderAccessDialogView: View {
    let onAuthorize: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            AppIconView(size: 80)

            VStack(spacing: 8) {
                Text("Bienvenue dans MacCleaner Pro")
                    .font(.title2.bold())

                Text(
                    "MacCleaner Pro souhaite analyser vos dossiers personnels afin d’identifier les fichiers volumineux et de vous aider à libérer de l’espace."
                )
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            }

            HStack {
                Button("Plus tard", action: onCancel)
                    .keyboardShortcut(.cancelAction)

                Button("Autoriser", action: onAuthorize)
                    .keyboardShortcut(.defaultAction)
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding(30)
        .frame(width: 420)
    }
}
