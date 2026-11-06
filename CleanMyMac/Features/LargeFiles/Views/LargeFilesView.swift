import SwiftUI

/// Vue principale du module Gros fichiers.
///
/// Responsabilités :
/// - Afficher l'en-tête du module.
/// - Proposer les différents emplacements à analyser.
/// - Permettre de régler la taille minimale des fichiers.
/// - Afficher les résultats de l'analyse.
///
/// La gestion des états et des actions utilisateur reste centralisée
/// dans cette vue. Les composants enfants seront principalement
/// chargés de présenter les informations.
struct LargeFilesView: View {

    // MARK: - État de l'analyse

    /// Taille minimale des fichiers recherchés, exprimée en mégaoctets.
    /// La valeur initiale est fixée à 500 Mo.
    @State private var minimumSize: Double = 500

    /// Indique si une analyse est actuellement en cours.
    @State private var isScanning = false

    /// Liste des fichiers volumineux détectés.
    @State private var results: [LargeFileItem] = []

    /// Emplacement actuellement sélectionné pour l'analyse.
    @State private var selectedLocation: ScanLocation?

    // MARK: - Interface

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // En-tête du module.
                LargeFilesHeaderView()

                // Sélection de l'emplacement à analyser.
                //ScanLocationSelectionView(
                  //  selectedLocation: $selectedLocation
                //)

                // Réglage du seuil minimal de taille.
                sizeFilterSection

                // Affichage des résultats.
                // Nous ajouterons cette partie lorsque le scanner sera connecté.
            }
            .padding(24)
            .frame(maxWidth: 900)
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Filtre de taille

    /// Présente le curseur permettant de régler la taille minimale.
    private var sizeFilterSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {

                Text("Taille minimale des fichiers")
                    .font(.headline)

                Text(
                    ByteCountFormatter.string(
                        fromByteCount: Int64(minimumSize * 1_000_000),
                        countStyle: .file
                    )
                )
                .font(.title2.bold())

                Slider(
                    value: $minimumSize,
                    in: 100...10_000,
                    step: 100
                )

                HStack {
                    Text("100 Mo")
                    Spacer()
                    Text("10 Go")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    LargeFilesView()
}
