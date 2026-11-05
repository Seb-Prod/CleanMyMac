//
//  JunkScannerService.swift
//  MacCleaner Pro
//
//  Description :
//  Service chargé d'analyser les dossiers sélectionnés
//  afin de détecter les fichiers potentiellement nettoyables.
//
//  Identifie notamment les fichiers présents dans les dossiers
//  Cache et les fichiers temporaires.
//
//  Fournit également une fonction permettant de déplacer
//  les fichiers sélectionnés vers la Corbeille macOS.
//
//  Ce service ne supprime jamais directement les fichiers.
//

import Foundation

struct JunkScannerService: Sendable {

    nonisolated func scan(folder: URL) throws -> [CleanableItem] {

        let keys: [URLResourceKey] = [
            .isRegularFileKey,
            .isDirectoryKey,
            .isSymbolicLinkKey,
            .fileSizeKey
        ]

        guard let enumerator = FileManager.default.enumerator(
            at: folder,
            includingPropertiesForKeys: keys,
            options: [.skipsPackageDescendants],
            errorHandler: { _, _ in true }
        ) else {
            return []
        }

        var results: [CleanableItem] = []

        let cacheFolderNames: Set<String> = [
            "cache",
            "caches"
        ]

        let temporaryExtensions: Set<String> = [
            "tmp",
            "temp"
        ]

        for case let fileURL as URL in enumerator {

            if results.count >= 1000 {
                break
            }

            let values = try? fileURL.resourceValues(
                forKeys: Set(keys)
            )

            guard values?.isRegularFile == true,
                  values?.isSymbolicLink != true,
                  let fileSize = values?.fileSize else {
                continue
            }

            let components = fileURL.pathComponents

            let insideCacheFolder = components.contains {
                cacheFolderNames.contains($0.lowercased())
            }

            let isTemporaryFile = temporaryExtensions.contains(
                fileURL.pathExtension.lowercased()
            )

            guard insideCacheFolder || isTemporaryFile else {
                continue
            }

            let size = Int64(fileSize)

            guard size > 0 else {
                continue
            }

            let reason = insideCacheFolder
                ? "Fichier situé dans un dossier Cache"
                : "Fichier temporaire"

            results.append(
                CleanableItem(
                    url: fileURL,
                    size: size,
                    reason: reason
                )
            )
        }

        return results.sorted {
            $0.size > $1.size
        }
    }

    nonisolated func moveToTrash(_ item: CleanableItem) throws {

        try FileManager.default.trashItem(
            at: item.url,
            resultingItemURL: nil
        )
    }
}
