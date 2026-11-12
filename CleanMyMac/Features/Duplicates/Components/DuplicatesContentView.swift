
import SwiftUI

/// Vue chargée d'afficher le contenu du module Doublons
/// selon l'état de l'analyse.
struct DuplicatesContentView: View {

    // MARK: - Properties

    let isScanning: Bool
    let hasScanned: Bool
    let duplicateGroups: [[URL]]
    let scanProgress: Double
    
    // MARK: - View

    var body: some View {
        Group {
            if isScanning {
                VStack(spacing: 12) {
                    Text("Recherche des fichiers en double...")
                        .font(.headline)

                    ProgressView(value: scanProgress)
                        .progressViewStyle(.linear)

                    Text("\(Int(scanProgress * 100)) %")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
            } else if !hasScanned {
                PlaceholderView(
                    title: "Aucune analyse effectuée",
                    message: "Lancez une analyse pour rechercher les fichiers en double.",
                    icon: "doc.on.doc"
                )
            } else if duplicateGroups.isEmpty {
                PlaceholderView(
                    title: "Aucun doublon trouvé",
                    message: "Aucun fichier identique n'a été détecté dans les répertoires analysés.",
                    icon: "checkmark.circle"
                )
            } else {
                DuplicateGroupsListView(
                    duplicateGroups: duplicateGroups,
                )
            }
        }
    }
}


// MARK: - Preview

#Preview("En cours de scan") {
    DuplicatesContentView(
        isScanning: true,
        hasScanned: false,
        duplicateGroups: [],
        scanProgress: 0
    )
}

#Preview("Invite au scan") {
    DuplicatesContentView(
        isScanning: false,
        hasScanned: false,
        duplicateGroups: [],
        scanProgress: 0
    )
}

#Preview("Aucun doublon") {
    DuplicatesContentView(
        isScanning: false,
        hasScanned: true,
        duplicateGroups: [],
        scanProgress: 0
    )
}
