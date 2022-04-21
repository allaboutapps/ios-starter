import Foundation

/// Global set of configuration values for this application.
public struct Config {
    
    public static let keyPrefix = "at.allaboutapps"

    // MARK: API

    public struct API {
        public static var baseURL: URL {
            switch Environment.current.serverEnvironment {
            case .dev:
                return URL(string: "https://example-dev.allaboutapps.at/api/v1")!
            case .staging:
                return URL(string: "https://example-staging.allaboutapps.at/api/v1")!
            case .live:
                return URL(string: "https://example.allaboutapps.at/api/v1")!
            }
        }

        public static let stubRequests = true
        public static var timeout: TimeInterval = 120.0

        public static var verboseLogging: Bool {
            switch Environment.current.buildConfig {
            case .debug:
                return true
            case .release:
                return false
            }
        }
    }
    
    // MARK: Cache
    
    public struct Cache {
        public static let defaultExpiration: TimeInterval = 5 * 60.0
    }

    // MARK: User Defaults

    public struct UserDefaultsKey {
        public static let lastUpdate = Config.keyPrefix + ".lastUpdate"
    }

    // MARK: Keychain

    public struct Keychain {
        public static let credentialStorageKey = "CredentialsStorage"
        public static let credentialsKey = "credentials"
    }
}
