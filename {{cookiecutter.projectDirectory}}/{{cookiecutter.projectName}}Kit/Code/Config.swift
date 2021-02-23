import Foundation
import Fetch

/// Global set of configuration values for this application.
public struct Config {
    
    static let keyPrefix = "at.allaboutapps"

    // MARK: API

    public struct API {
        
        static var baseURL: URL {
            switch Environment.current.serverEnvironment {
            case .dev:
                return URL(string: "https://dev.allaboutapps.at")!
            case .staging:
                return URL(string: "https://staging.allaboutapps.at")!
            case .live:
                return URL(string: "https://live.allaboutapps.at")!
            }
        }

        static let stubRequests = true
        static var timeout: TimeInterval = 120.0

        static var verboseLogging: Bool {
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
        static let defaultExpiration: Expiration = .seconds(5 * 60.0)
    }

    // MARK: User Defaults

    public struct UserDefaultsKey {
        static let lastUpdate = Config.keyPrefix + ".lastUpdate"
    }

    // MARK: Keychain

    public struct Keychain {
        static let credentialStorageKey = "CredentialsStorage"
        static let credentialsKey = "credentials"
    }
}
