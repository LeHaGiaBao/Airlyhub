import Foundation

enum AppConfig {
    enum Environment: String {
        case dev = "DEV", stg = "STG", prod = "PROD"
    }

    static let environment: Environment = {
        let raw = Bundle.main.infoDictionary?["APP_ENV"] as? String ?? "DEV"
        return Environment(rawValue: raw) ?? .dev
    }()

    /// Marketing version, e.g. "1.0" (CFBundleShortVersionString).
    static let appVersion: String =
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"

    /// Build number, e.g. "1" (CFBundleVersion).
    static let buildNumber: String =
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"

    /// Combined, e.g. "1.0 (1)" — handy for settings/about screens.
    static let displayVersion: String = "\(appVersion) (\(buildNumber))"
}
