import AppKit
import SwiftUI

/// Affiche la liste des fichiers volumineux d'un emplacement.
struct LargeFilesListView: View {

    let location: ScanLocation
    let files: [LargeFileItem]

    @Binding var selectedFileIDs: Set<String>

    let onRequestDelete: () -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var isDeleteConfirmationPresented = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(location.title)
                .font(.title2)
                .fontWeight(.semibold)

            Text("\(files.count) fichiers volumineux détectés")
                .foregroundStyle(.secondary)

            Divider()

            if files.isEmpty {
                ContentUnavailableView(
                    "Aucun fichier trouvé",
                    systemImage: "doc",
                    description: Text(
                        "Aucun fichier ne correspond au filtre actuel."
                    )
                )
            } else {
                List(files) { file in
                    HStack(spacing: 12) {
                        Toggle(
                            "",
                            isOn: Binding(
                                get: {
                                    selectedFileIDs.contains(file.id)
                                },
                                set: { isSelected in
                                    if isSelected {
                                        selectedFileIDs.insert(file.id)
                                    } else {
                                        selectedFileIDs.remove(file.id)
                                    }
                                }
                            )
                        )
                        .labelsHidden()
                        .toggleStyle(.checkbox)

                        Image(systemName: file.systemImage)
                            .font(.title2)
                            .foregroundStyle(.secondary)
                            .frame(width: 30)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(file.name)
                                .fontWeight(.medium)
                                .lineLimit(1)

                            Text(file.contentType ?? file.fileExtension)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 4) {
                            Text(file.formattedSize)
                                .fontWeight(.medium)

                            Text("Créé le \(file.formattedCreationDate)")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Text(
                                "Dernier accès : \(file.formattedLastAccessDate)"
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }

                        Button {
                            NSWorkspace.shared.activateFileViewerSelecting([
                                file.url
                            ])
                        } label: {
                            Image(systemName: "folder")
                                .font(.system(size: 16))
                        }
                        .buttonStyle(.borderless)
                        .help("Afficher dans le Finder")
                    }
                    .padding(.vertical, 4)
                }
            }

            HStack {
                Button("Anuller") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)

                Spacer()

                Button(role: .destructive) {
                    isDeleteConfirmationPresented = true
                } label: {
                    Label(
                        "Mettre à la Corbeille (\(selectedFileIDs.count))",
                        systemImage: "trash"
                    )
                }
                .disabled(selectedFileIDs.isEmpty)
                .tint(.red)
            }
        }
        .padding(24)
        .frame(minWidth: 800, minHeight: 550)
        .confirmationDialog(
            "Mettre les fichiers sélectionnés à la Corbeille ?",
            isPresented: $isDeleteConfirmationPresented,
            titleVisibility: .visible
        ) {
            Button("Mettre à la Corbeille", role: .destructive) {
                onRequestDelete()
            }

            Button("Annuler", role: .cancel) {}
        } message: {
            Text("Les fichiers sélectionnés seront déplacés vers la Corbeille.")
        }
    }
}
