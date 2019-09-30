import Foundation

/// Defines the environment the app is currently running.
/// The environment is determined by the target's Configuration name
public struct Environment: Equatable {
    
    /// Represents base build configurations
    public enum BuildConfig: String {
        case debug, release
    }
    
    /// The build config of the Environment
    public let buildConfig: BuildConfig
    
    /// Represents versions refering to the used backend
    public enum BuildVersion: String {
        case live, dev, staging
    }
    
    /// The version of the Environment
    public let buildVersion: BuildVersion

    /// Returns the current enviroment the app is currently running.
    public static var current: Environment = {
        guard let configurationString = Bundle.main.infoDictionary!["_Configuration"] as? String else {
            fatalError("Info.plist does not contain the key _Configuration. Add this key with value $(CONFIGURATION)")
        }
        let split = configurationString.components(separatedBy: "-")
        
        if split.count == 1 {
            guard
                let buildConfig = BuildConfig(rawValue: split[0].lowercased()),
                let serverEnvVar = envVar(named: "SERVER_ENVIRONMENT"),
                let buildVersion = BuildVersion(rawValue: serverEnvVar.lowercased()) else {
                fatalError("Invalid build configuration")
            }
            return Environment(buildConfig: buildConfig, buildVersion: buildVersion)
        } else if split.count == 2 {
            guard
                let buildConfig = BuildConfig(rawValue: split[0].lowercased()),
                let buildVersion = BuildVersion(rawValue: split[1].lowercased()) else {
                fatalError("Invalid build configuration")
            }
            return Environment(buildConfig: buildConfig, buildVersion: buildVersion)
        } else {
            fatalError("Invalid build configuration")
        }
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

extension Environment: CustomStringConvertible {
    
    public var description: String {
        return "\(buildVersion.rawValue)-\(buildConfig.rawValue)"
    }
    
}
