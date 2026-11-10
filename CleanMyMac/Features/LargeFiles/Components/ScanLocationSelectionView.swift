import SwiftUI

/// Affiche les répertoires personnels et leurs statistiques.
struct ScanLocationSelectionView: View {

    /// Action appelée lorsqu'un emplacement est ouvert.
    let onOpenLocation: (ScanLocation) -> Void

    /// Fournit les statistiques des fichiers pour un emplacement.
    let statisticsForLocation:
        (ScanLocation) -> (fileCount: Int, totalSize: Int64)

    let statusForLocation: (ScanLocation) -> LargeFilesScanStatus

    /// Liste des emplacements personnels disponibles.
    let locations: [ScanLocation]
    
    private var visibleLocations: [ScanLocation] {
        locations.filter { location in
            switch statusForLocation(location) {
            case .scanning, .failed:
                return true

            case .completed:
                return statisticsForLocation(location).fileCount > 0

            case .notScanned:
                return false
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(visibleLocations.enumerated()), id: \.element.id) { index, location in
                let statistics = statisticsForLocation(location)

                ScanLocationRow(
                    location: location,
                    index: index,
                    totalCount: visibleLocations.count,
                    status: statusForLocation(location),
                    fileCount: statistics.fileCount,
                    totalSize: statistics.totalSize,
                    onOpen: {
                        onOpenLocation(location)
                    }
                )
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(nsColor: .quaternarySystemFill))
        )

    }
}
