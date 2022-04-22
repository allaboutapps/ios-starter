import Foundation

/// Defines the environment the app is currently running.
/// The environment is determined by the target's Configuration name
public struct AppEnvironment: Equatable {
    
    /// Represents base build configurations
    public enum BuildConfig: String {
        case debug, release
    }
    
    /// The build config of the Environment
    public let buildConfig: BuildConfig
    
    /// Represents environment referring to the used backend
    public enum ServerEnvironment: String {
        case live, dev, staging
    }
    
    /// The sever environment
    public let serverEnvironment: ServerEnvironment

    /// Returns the current environment the app is currently running.
    public static var current: AppEnvironment = {
        guard let configurationString = Bundle.main.infoDictionary!["_Configuration"] as? String else {
            fatalError("Info.plist does not contain the key _Configuration. Add this key with value $(CONFIGURATION)")
        }
        
        guard let serverEnvironmentString = Bundle.main.infoDictionary!["_ServerEnvironment"] as? String else {
            fatalError("Info.plist does not contain the key _ServerEnvironment. Add this key with value $(SERVER_ENVIRONMENT)")
        }
        
        let split = configurationString.components(separatedBy: "-")
        
        guard
            split.count == 2,
            let buildConfig = BuildConfig(rawValue: split[0].lowercased()),
            let serverEnvironment = ServerEnvironment(rawValue: serverEnvironmentString.lowercased()) else {
            fatalError("Invalid build configuration")
        }
        
        return AppEnvironment(buildConfig: buildConfig, serverEnvironment: serverEnvironment)
    }()

    /// Returns the current App version, build number and environment
    /// e.g. `1.0 (3) release-dev`
    public var appInfo: String {
        guard let infoDict = Bundle.main.infoDictionary,
            let versionNumber = infoDict["CFBundleShortVersionString"],
            let buildNumber = infoDict["CFBundleVersion"] else {
            return ""
        }

        return "\(versionNumber) (\(buildNumber)) \(description)"
    }
    
    public static func envVar(named name: String) -> String? {
        return ProcessInfo.processInfo.environment[name]
    }
}

extension AppEnvironment: CustomStringConvertible {
    public var description: String {
        return "\(serverEnvironment.rawValue)-\(buildConfig.rawValue)"
    }
}
