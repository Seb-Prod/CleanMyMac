import SwiftUI

/// Affiche les messages d'information et les éventuelles erreurs du nettoyage.
struct CleaningFeedbackView: View {

    /// Message informatif affiché après une opération.
    let statusMessage: String

    /// Message d'erreur éventuel.
    let errorMessage: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            if !statusMessage.isEmpty {
                Text(statusMessage)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if let errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
    }
}
