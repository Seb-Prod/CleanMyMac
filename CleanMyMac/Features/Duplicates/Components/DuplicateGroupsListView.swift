import SwiftUI

/// Vue chargée d'afficher les groupes de fichiers identiques.
struct DuplicateGroupsListView: View {

    // MARK: - Properties

    let duplicateGroups: [[URL]]

    // MARK : - Methods

    private func formattedSize(for fileURL: URL) -> String {
        let values = try? fileURL.resourceValues(forKeys: [.fileSizeKey])
        let size = Int64(values?.fileSize ?? 0)

        return ByteCountFormatter.string(
            fromByteCount: size,
            countStyle: .file
        )
    }
    
    private func recoverableSize(for group: [URL]) -> String {
        let totalSize = group.reduce(Int64.zero) { total, fileURL in
            let values = try? fileURL.resourceValues(forKeys: [.fileSizeKey])
            let size = Int64(values?.fileSize ?? 0)
            return total + size
        }

        let recoverableSize = totalSize - (totalSize / Int64(group.count))

        return ByteCountFormatter.string(
            fromByteCount: recoverableSize,
            countStyle: .file
        )
    }

    // MARK: - View

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(
                    Array(duplicateGroups.enumerated()),
                    id: \.offset
                ) { index, group in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Groupe \(index + 1)")
                                .font(.headline)

                            Spacer()

                            Text("\(group.count) fichiers")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            Text("Récupérable : \(recoverableSize(for: group))")
                                .font(.caption)
                                .foregroundStyle(.green)
                        }

                        ForEach(group, id: \.path) { fileURL in
                            HStack(spacing: 12) {
                                Image(systemName: "doc")
                                    .foregroundStyle(.secondary)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(fileURL.lastPathComponent)
                                        .font(.body)
                                        .lineLimit(1)

                                    Text(
                                        fileURL.deletingLastPathComponent().path
                                    )
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)

                                    Text(formattedSize(for: fileURL))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()
                            }
                            .padding(12)
                            .background(Color.primary.opacity(0.035))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(nsColor: .quaternarySystemFill))
                    )
                }
            }
            .padding(8)
        }
    }
}
