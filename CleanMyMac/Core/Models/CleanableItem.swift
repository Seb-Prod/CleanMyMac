//
//  CleanableItem.swift
//  MacCleaner Pro
//
//  Description :
//  Modèle représentant un fichier détecté comme potentiellement
//  nettoyable par MacCleaner Pro.
//  Contient son emplacement, sa taille et la raison de sa détection.
//
//  Ce fichier ne réalise aucune suppression : il stocke uniquement
//  les informations nécessaires à l'affichage et au nettoyage.
//

import Foundation

struct CleanableItem: Identifiable, Sendable {

    let url: URL
    let size: Int64
    let reason: String

    var id: String {
        url.path
    }

    var name: String {
        url.lastPathComponent
    }

    var formattedSize: String {
        ByteCountFormatter.string(
            fromByteCount: size,
            countStyle: .file
        )
    }
}
