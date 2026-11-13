import SwiftUI

struct ExcludedFolderRow: View {
    let folder: ExcludedFolder

    private var analysisNames: String {
        folder.excludedAnalyses
            .map { analysis in
                switch analysis {
                case .largeFiles:
                    return "Gros fichiers"
                case .duplicates:
                    return "Doublons"
                case .junk:
                    return "Nettoyage"
                }
            }
            .sorted()
            .joined(separator: ", ")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(folder.url.lastPathComponent)
                .font(.headline)

            Text(folder.url.path)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)

            Text("Analyses ignorées : \(analysisNames)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }
}
