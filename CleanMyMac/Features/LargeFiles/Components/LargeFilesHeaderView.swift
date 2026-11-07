import SwiftUI

/// En-tête spécialisé du module Gros fichiers.
///
/// Utilise PageHeader pour conserver une présentation
/// cohérente avec les autres pages de l'application.
struct LargeFilesHeaderView: View {

    let onScan: () -> Void
    let isScanning: Bool
    let onSelectFolders: () -> Void

    var body: some View {
        PageHeader(
            title: "Gros fichiers",
            subtitle:
                "Identifiez les fichiers volumineux qui occupent inutilement de l'espace sur votre Mac."
        ) {
            HStack(spacing: 12) {
                Button(action: onSelectFolders) {
                    Label(
                        "Choisir les dossiers",
                        systemImage: "folder.badge.plus"
                    )
                }

                PrimaryButton(
                    title: isScanning ? "Analyse en cours..." : "Analyser",
                    icon: "magnifyingglass",
                    action: onScan
                )
                .disabled(isScanning)
            }
        }
    }
}
