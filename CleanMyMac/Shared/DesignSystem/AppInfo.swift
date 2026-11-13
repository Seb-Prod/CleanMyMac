import Foundation

/// Fournit les informations générales de MacCleaner Pro.
enum AppInfo {

    // MARK: - Properties

    /// Nom de l'application récupéré depuis le bundle.
    static var name: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleName")
            as? String ?? "MacCleaner Pro"
    }

    // Récupère automatiquement la version et le build depuis Xcode
    static var appVersion: String {
        let version =
            Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            ?? "1.0"
        let build =
            Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "Version \(version) (\(build))"
    }

    // Récupère automatiquement l'année en cour
    static var currentDate: String {
        return "\(Calendar.current.component(.year, from: Date()))"
    }
}
