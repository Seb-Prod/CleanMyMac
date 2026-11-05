//
//  SystemSnapshot.swift
//  MacCleaner Pro
//
//  Description :
//  Modèle contenant un instantané des principales ressources
//  du Mac : stockage total, espace utilisé, espace disponible
//  et mémoire vive installée.
//
//  Fournit également les propriétés nécessaires pour afficher
//  ces informations dans un format lisible par l'utilisateur.
//
//  Ce fichier ne collecte pas lui-même les informations système.
//

import Foundation

struct SystemSnapshot {

    let totalStorage: Int64
    let availableStorage: Int64
    let usedStorage: Int64
    let totalMemory: UInt64

    var storageUsage: Double {
        guard totalStorage > 0 else { return 0 }

        return Double(usedStorage) / Double(totalStorage)
    }

    var formattedTotalStorage: String {
        ByteCountFormatter.string(
            fromByteCount: totalStorage,
            countStyle: .file
        )
    }

    var formattedAvailableStorage: String {
        ByteCountFormatter.string(
            fromByteCount: availableStorage,
            countStyle: .file
        )
    }

    var formattedUsedStorage: String {
        ByteCountFormatter.string(
            fromByteCount: usedStorage,
            countStyle: .file
        )
    }

    var formattedMemory: String {
        ByteCountFormatter.string(
            fromByteCount: Int64(clamping: totalMemory),
            countStyle: .memory
        )
    }
}
