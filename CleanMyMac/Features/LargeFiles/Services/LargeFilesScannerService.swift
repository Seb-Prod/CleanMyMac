import Foundation

/// Service chargé de rechercher les fichiers volumineux sur le Mac.
///
/// Responsabilités :
/// - Parcourir récursivement un dossier sélectionné.
/// - Identifier les fichiers répondant au seuil de taille minimal.
/// - Ignorer les dossiers et les liens symboliques.
/// - Classer les résultats du plus volumineux au moins volumineux.
///
/// Ce service ne réalise aucune suppression et ne déplace aucun fichier.
/// La gestion des résultats et des actions utilisateur reste dans LargeFilesView.
struct LargeFilesScannerService: Sendable {

    nonisolated init() {}

    /// Analyse un dossier à la recherche de fichiers volumineux.
    ///
    /// - Parameters:
    ///   - folder : Dossier de départ de l'analyse.
    ///   - minimumSize : Taille minimale acceptée, exprimée en octets.
    ///
    /// - Returns : Liste des fichiers détectés, triés par taille décroissante.
    ///
    /// - Throws : Une éventuelle erreur lors de l'initialisation de l'énumérateur.
    nonisolated func scan(
        folder: URL,
        minimumSize: Int64
    ) throws -> [LargeFileItem] {

        // Définition des propriétés de fichiers nécessaires à l'analyse.
        // Cela évite de récupérer inutilement toutes les métadonnées.
        let keys: [URLResourceKey] = [
            .isRegularFileKey,
            .isSymbolicLinkKey,
            .fileSizeKey,
        ]

        // Création d'un énumérateur permettant de parcourir
        // le dossier sélectionné ainsi que ses sous-dossiers.
        //
        // L'option .skipsPackageDescendants évite de parcourir
        // le contenu des paquets macOS, comme certaines applications.
        //
        // Le gestionnaire d'erreur permet de continuer l'analyse
        // lorsqu'un fichier ou un sous-dossier n'est pas accessible.
        guard
            let enumerator = FileManager.default.enumerator(
                at: folder,
                includingPropertiesForKeys: keys,
                options: [.skipsPackageDescendants],
                errorHandler: { _, error in
                    // Signale l'erreur et interrompt le parcours du dossier concerné.
                    print(
                        "Erreur d'accès à \(folder.path) : \(error.localizedDescription)"
                    )
                    return false
                }
            )
        else {
            // Impossible de créer l'énumérateur pour ce dossier.
            throw NSError(
                domain: "LargeFilesScannerService",
                code: 1,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Impossible d'accéder au dossier \(folder.lastPathComponent)."
                ]
            )
        }

        // Tableau temporaire contenant les fichiers détectés.
        var results: [LargeFileItem] = []

        // Parcours de chaque élément trouvé dans le dossier.
        for case let fileURL as URL in enumerator {

            // Récupération des métadonnées du fichier.
            // Si elles ne sont pas accessibles, on ignore cet élément.
            let values = try? fileURL.resourceValues(
                forKeys: Set(keys)
            )

            // Vérification que l'élément est bien un fichier classique,
            // qu'il n'est pas un lien symbolique et que sa taille est connue.
            guard
                values?.isRegularFile == true,
                values?.isSymbolicLink != true,
                let fileSize = values?.fileSize
            else {
                continue
            }

            // Conversion de la taille en Int64 pour faciliter
            // les comparaisons et les calculs de stockage.
            let size = Int64(fileSize)

            // On conserve uniquement les fichiers dont la taille
            // est supérieure ou égale au seuil choisi par l'utilisateur.
            guard size >= minimumSize else {
                continue
            }

            // Création du modèle représentant le fichier détecté.
            results.append(
                LargeFileItem(
                    url: fileURL,
                    size: size
                )
            )
        }

        // Classement des fichiers du plus volumineux au moins volumineux.
        return results.sorted {
            $0.size > $1.size
        }
    }

}
