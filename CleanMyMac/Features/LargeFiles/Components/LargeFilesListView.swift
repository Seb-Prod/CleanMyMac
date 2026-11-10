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

    @State private var isAscending = false

    private var sortedFiles: [LargeFileItem] {
        files.sorted {
            isAscending
                ? $0.size < $1.size
                : $0.size > $1.size
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(location.title)
                .font(.title2)
                .fontWeight(.semibold)

            HStack {
                SectionTitle(
                    subtitle: "\(files.count) fichiers volumineux détectés"
                )

                Spacer()

                Picker("Trier par taille", selection: $isAscending) {
                    Text("Plus gros d'abord").tag(false)
                    Text("Plus petits d'abord").tag(true)
                }
                .pickerStyle(.menu)
                .frame(width: 180)
            }

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
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(
                            Array(sortedFiles.enumerated()),
                            id: \.element.id
                        ) {
                            index,
                            file in
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

                                    InfoLabel(
                                        title: "Créé le",
                                        value: file.formattedCreationDate,
                                        icon: "calendar"
                                    )

                                    InfoLabel(
                                        title: "Dernier accès",
                                        value: file.formattedLastAccessDate,
                                        icon: "clock"
                                    )
                                }

                                Button {
                                    NSWorkspace.shared
                                        .activateFileViewerSelecting([
                                            file.url
                                        ])
                                } label: {
                                    Image(systemName: "folder")
                                        .font(.system(size: 16))
                                }
                                .buttonStyle(.borderless)
                                .help("Afficher dans le Finder")
                            }
                            .padding(12)
                            .background {
                                UnevenRoundedRectangle(
                                    topLeadingRadius: index == 0 ? 10 : 0,
                                    bottomLeadingRadius: index == sortedFiles.count - 1 ? 10 : 0,
                                    bottomTrailingRadius: index == sortedFiles.count - 1 ? 10 : 0,
                                    topTrailingRadius: index == 0 ? 10 : 0
                                )
                                .fill(
                                    index.isMultiple(of: 2)
                                        ? Color.primary.opacity(0.035)
                                        : Color.primary.opacity(0.07)
                                )
                            }
                        }
                    }
                }
            }

            HStack {
                CancelButton(title: "Annuler") {
                    dismiss()
                }

                Spacer()

                DestructiveButton(
                    title: "Mettre à la Corbeille (\(selectedFileIDs.count))",
                    icon: "trash",
                    isDisabled: selectedFileIDs.isEmpty
                ) {
                    isDeleteConfirmationPresented = true
                }
            }
        }
        .padding(24)
        .frame(minWidth: 800, minHeight: 550)
        .overlay {
            if isDeleteConfirmationPresented {
                AppConfirmationDialogView(
                    title: "Confirmer la suppression",
                    message:
                        "Les fichiers sélectionnés seront déplacés vers la Corbeille.",
                    confirmTitle: "Mettre à la Corbeille",
                    onConfirm: {
                        isDeleteConfirmationPresented = false
                        onRequestDelete()
                    },
                    onCancel: {
                        isDeleteConfirmationPresented = false
                    }
                )
            }
        }
    }
}
