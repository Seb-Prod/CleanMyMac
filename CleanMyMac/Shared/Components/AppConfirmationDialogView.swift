import SwiftUI

struct AppConfirmationDialogView: View {
    let title: String
    let message: String
    let confirmTitle: String
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.25)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                AppIconView(size: 64)

                VStack(spacing: 8) {
                    Text(title)
                        .font(.title2.bold())

                    Text(message)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Button("Annuler", action: onCancel)
                        .keyboardShortcut(.cancelAction)

                    Button(confirmTitle, role: .destructive, action: onConfirm)
                        .keyboardShortcut(.defaultAction)
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                }
            }
            .padding(30)
            .frame(width: 420)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 20)
        }
        .animation(.easeInOut(duration: 0.2), value: true)
    }
}
