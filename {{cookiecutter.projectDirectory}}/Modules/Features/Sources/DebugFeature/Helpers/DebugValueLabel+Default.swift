import Foundation

public extension DebugValueLabel {

    static let appVersion = DebugValueLabel(id: "appVersion", localizedName: "Version")
    static let appBuildNumber = DebugValueLabel(id: "appBuildNumber", localizedName: "Build Number")
    static let appServerEnvironment = DebugValueLabel(id: "serverEnvironment", localizedName: "Server Environment")
    static let appBuildConfig = DebugValueLabel(id: "buildConfig", localizedName: "Build Config")
    static let appBundleId = DebugValueLabel(id: "bundleId", localizedName: "Bundle Identifier")

    static let userAppStart = DebugValueLabel(id: "appStart", localizedName: "App Start")
    static let userLocale = DebugValueLabel(id: "locale", localizedName: "Locale")

    static let deviceOSVersion = DebugValueLabel(id: "deviceOSVersion", localizedName: "OS Version")
    static let deviceOSModel = DebugValueLabel(id: "deviceOSModel", localizedName: "Model")

    static let notificationsPushToken = DebugValueLabel(id: "pushToken", localizedName: "Push Token")
    static let notificationsEnvironment = DebugValueLabel(id: "notificationEnvironment", localizedName: "Environment")
    static let notificationsConfigured = DebugValueLabel(id: "notificationConfigured", localizedName: "Configured?")
}
