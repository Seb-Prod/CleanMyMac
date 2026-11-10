import SwiftUI

struct StorageSummaryView: View {
    let availableStorage: Int64
    let recoverableSize: Int64
    let managedTrashSize: Int64
    let onEmptyTrash: () -> Void

    private var formattedAvailableStorage: String {
        ByteCountFormatter.string(
            fromByteCount: availableStorage,
            countStyle: .file
        )
    }

    private var formattedRecoverableSize: String {
        ByteCountFormatter.string(
            fromByteCount: recoverableSize,
            countStyle: .file
        )
    }

    var body: some View {
        HStack {
            HStack(spacing: 20) {
                InfoLabel(
                    title: "Espace disponible",
                    value: formattedAvailableStorage,
                    icon: "internaldrive"
                )

                InfoLabel(
                    title: "Espace récupérable",
                    value: formattedRecoverableSize,
                    icon: "trash"
                )

                InfoLabel(
                    title: "Dans la Corbeille",
                    value: ByteCountFormatter.string(
                        fromByteCount: managedTrashSize,
                        countStyle: .file
                    ),
                    icon: "trash"
                )
            }.padding(16)
                .background(.blue.gradient)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Spacer()

            DestructiveButton(
                title: "Vider la Corbeille",
                icon: "trash",
                isDisabled: managedTrashSize == 0,
                action: onEmptyTrash
            )
        }

    }
}
