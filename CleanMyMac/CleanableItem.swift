
import Foundation

struct CleanableItem: Identifiable, Sendable {

    let url: URL
    let size: Int64
    let reason: String

    var id: String {
        url.path
    }

    var name: String {
        url.lastPathComponent
    }

    var formattedSize: String {
        ByteCountFormatter.string(
            fromByteCount: size,
            countStyle: .file
        )
    }
}
