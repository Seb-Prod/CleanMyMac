
import SwiftUI

/// Affiche un indicateur de progression avec un message personnalisable.
///
/// Utilisé pendant les opérations dont la durée n'est pas connue,
/// comme l'analyse des fichiers ou la récupération des informations système.
struct AppProgressView: View {

    /// Message affiché sous l'indicateur de progression.
    let message: String

    var body: some View {
        VStack {
            Spacer()

            ProgressView(message)
                .controlSize(.large)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    AppProgressView(message: "Lecture des informations système...")
}
