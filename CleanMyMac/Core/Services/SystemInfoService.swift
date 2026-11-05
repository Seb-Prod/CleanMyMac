//
//  SystemInfoService.swift
//  MacCleaner Pro
//
//  Description :
//  Service chargé de récupérer les informations matérielles
//  et système du Mac.
//
//  Collecte notamment la capacité totale du stockage,
//  l'espace disponible, l'espace utilisé et la mémoire vive.
//
//  Les données collectées sont regroupées dans un objet
//  SystemSnapshot pour être utilisées par l'interface.
//

import Foundation

struct SystemInfoService {

    func getSnapshot() -> SystemSnapshot {

        let diskURL = URL(fileURLWithPath: "/")

        let values = try? diskURL.resourceValues(
            forKeys: [
                .volumeTotalCapacityKey,
                .volumeAvailableCapacityKey
            ]
        )

        let total = Int64(
            values?.volumeTotalCapacity ?? 0
        )

        let available = Int64(
            values?.volumeAvailableCapacity ?? 0
        )

        let used = max(0, total - available)

        return SystemSnapshot(
            totalStorage: total,
            availableStorage: available,
            usedStorage: used,
            totalMemory: ProcessInfo.processInfo.physicalMemory
        )
    }
}


