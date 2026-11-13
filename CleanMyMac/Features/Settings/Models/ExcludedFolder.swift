import Foundation

enum AnalysisType: String, Codable, Hashable, CaseIterable {
    case largeFiles
    case duplicates
    case junk
}

struct ExcludedFolder: Identifiable, Codable, Hashable {
    let id: UUID
    let url: URL
    var excludedAnalyses: Set<AnalysisType>

    init(
        id: UUID = UUID(),
        url: URL,
        excludedAnalyses: Set<AnalysisType>
    ) {
        self.id = id
        self.url = url
        self.excludedAnalyses = excludedAnalyses
    }
}
