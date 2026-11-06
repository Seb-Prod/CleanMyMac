import SwiftUI

/// En-tête spécialisé du module Gros fichiers.
///
/// Utilise PageHeader pour conserver une présentation
/// cohérente avec les autres pages de l'application.
struct LargeFilesHeaderView: View {

    var body: some View {
        PageHeader(
            title: "Gros fichiers",
            subtitle: "Identifiez les fichiers volumineux qui occupent inutilement de l'espace sur votre Mac."
        ) {
            // Aucun bouton ni action supplémentaire sur cette page.
            EmptyView()
        }
    }
}

// MARK: - Aperçu
#Preview {
    LargeFilesHeaderView()
        .padding()
}
