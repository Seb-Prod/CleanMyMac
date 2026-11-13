import SwiftUI

struct ExclusionSelectionView: View {
    @Binding var selectedAnalyses: Set<AnalysisType>

    private let analyses: [(type: AnalysisType, title: String)] = [
        (.largeFiles, "Gros fichiers"),
        (.duplicates, "Fichiers en double"),
        (.junk, "Nettoyage")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Exclure des analyses")
                .font(.headline)

            ForEach(analyses, id: \.type) { analysis in
                Toggle(
                    analysis.title,
                    isOn: Binding(
                        get: {
                            selectedAnalyses.contains(analysis.type)
                        },
                        set: { isSelected in
                            if isSelected {
                                selectedAnalyses.insert(analysis.type)
                            } else {
                                selectedAnalyses.remove(analysis.type)
                            }
                        }
                    )
                )
                .toggleStyle(.checkbox)
            }
        }
    }
}
