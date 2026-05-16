import Foundation

enum AppConfig {
    enum Environment: String {
        case dev = "DEV", stg = "STG", prod = "PROD"
    }

    static let environment: Environment = {
        let raw = Bundle.main.infoDictionary?["APP_ENV"] as? String ?? "DEV"
        return Environment(rawValue: raw) ?? .dev
    }()
}
