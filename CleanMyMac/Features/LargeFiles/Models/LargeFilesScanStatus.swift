import Foundation

/// Représente l'état d'analyse d'un répertoire.
enum LargeFilesScanStatus: Sendable {

    /// Le répertoire n'a pas encore été analysé.
    case notScanned

    /// Le répertoire est en cours d'analyse.
    case scanning

    /// L'analyse du répertoire est terminée.
    case completed

    /// L'analyse du répertoire a échoué.
    case failed
}
