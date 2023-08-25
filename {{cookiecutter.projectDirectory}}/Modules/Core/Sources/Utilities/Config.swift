import Foundation

/// Global set of configuration values for this application.
public enum Config {

    public static let keyPrefix = "at.allaboutapps"

    // MARK: API

    public enum API {
        public static var baseURL: URL {
            switch AppEnvironment.current.serverEnvironment {
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
            switch AppEnvironment.current.buildConfig {
            case .debug:
                return true
            case .release:
                return false
            }
        }
    }

    // MARK: Cache

    public enum Cache {
        public static let defaultExpiration: TimeInterval = 5 * 60.0
    }

    // MARK: User Defaults

    public enum UserDefaultsKey {
        public static let lastUpdate = Config.keyPrefix + ".lastUpdate"
    }

    // MARK: Keychain

    public enum Keychain {
        public static let credentialStorageKey = "CredentialsStorage"
        public static let credentialsKey = "credentials"
    }

    // MARK: Force Update

    public enum ForceUpdate {

        /// URL of the statically hosted version file, used by force update feature.
        public static let publicVersionURL = URL(string: "https://public.allaboutapps.at/config/{{cookiecutter.projectName|lower|replace(' ', '-')}}/version.json")!
    }
}
