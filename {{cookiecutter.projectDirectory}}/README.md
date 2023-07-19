# test-debug-screen

### ForceUpdate

The project comes with the ability to show a blocker screen, if needed. This blocker screen tells the user to update their app.

Change the path of the statically hosted version file at `Core.Utilities.Config.ForceUpdate.publicVersionURL`:

```swift
public enum ForceUpdate {

    /// url of the statically hosted version file, used by force update feature
    public static let publicVersionURL = URL(string: "https://public.allaboutapps.at/config/test/version.json")!
}
```

[Force Update GitHub](https://github.com/allaboutapps/force-update-ios)

### Debug

The project comes with a pre-configured debug screen that can easily be extended.

#### `DebugController`

Add values to the debug screen by calling either of the functions:

- `public func addStatic(_ label: DebugValueLabel, to section: DebugSection, value: String?)`
- `public func add(_ label: DebugValueLabel, to section: DebugSection, value: @autoclosure @escaping (() -> String?))`
- `public func add(_ label: DebugValueLabel, to section: DebugSection, value: @escaping (() -> String?))`

> ###### Notes
> - Adding a value with the same `id` twice will override the value.
> - Only values added with any of the above-mentioned methods are added to the debug screen.
> - Sections and Values are ordered by time of insert. This means they will appear in the order they were added to the `DebugController`.

#### Disable feature

By default, it is enabled. However, it can be disabled in `Core.Utilities.Config.Debug.enabled`:

```swift
public enum Debug {
    
    /// Feature flag that determines if the debug feature is enabled.
    public static let enabled: Bool = true
}
```

#### Sections

Debug values are grouped by sections, making the information easier to read. The following sections exist by default:

```swift
public extension DebugSection {
    
    static let app = DebugSection(id: "app", localizedName: "App")
    static let user = DebugSection(id: "user", localizedName: "User")
    static let device = DebugSection(id: "device", localizedName: "Device")
    static let notifications = DebugSection(id: "notifications", localizedName: "Notifications")
}
```

You can easily create your own section by extending `DebugSection`:

```swift
public extension DebugSection {
    
    static let yourSection = DebugSection(id: "yourSection", localizedName: "Your Section")
}
```

> ###### Notes
> Make sure that your `id` is unique, as it is used for diffing and identifying the section.

#### Values

The following values exist by default:

```swift
public extension DebugValueLabel {

    static let appBuildNumber = DebugValueLabel(id: "appBuildNumber", localizedName: "Build Number")
    static let appVersion = DebugValueLabel(id: "appVersion", localizedName: "Version")
    static let appServerEnvironment = DebugValueLabel(id: "serverEnvironment", localizedName: "Server Environment")
    static let appBuildConfig = DebugValueLabel(id: "buildConfig", localizedName: "Build Config")
    static let appBundleId = DebugValueLabel(id: "bundleId", localizedName: "Bundle Identifier")

    static let userLocale = DebugValueLabel(id: "locale", localizedName: "Locale")
    static let userAppStart = DebugValueLabel(id: "appStart", localizedName: "App Start")

    static let deviceOSVersion = DebugValueLabel(id: "deviceOSVersion", localizedName: "OS Version")
    static let deviceOSModel = DebugValueLabel(id: "deviceOSModel", localizedName: "Model")

    static let notificationsPushToken = DebugValueLabel(id: "pushToken", localizedName: "Push Token")
    static let notificationsEnvironment = DebugValueLabel(id: "notificationEnvironment", localizedName: "Environment")
    static let notificationsConfigured = DebugValueLabel(id: "notificationConfigured", localizedName: "Configured?")
}
```

You can easily create your own values by extending `DebugValueLabel`:

```swift
public extension DebugValueLabel {
    
    static let yourValue = DebugValueLabel(id: "yourValue", localizedName: "Your Value")
}
```

Two types of values can be added to sections:

- static values
- dynamic values

##### Static Values

> ###### Notes
> Static values are evaluated when the value is inserted into the `DebugController`.

Static values can be added like this:

```swift
debugController.addStatic(.yourValue, to: .yourSection, value: "Hello, World!")
```

##### Dynamic Values

> ###### Notes
> Dynamic values are wrapped in a closure and evaluated when the Debug screen is shown.

Dynamic values can be added like this:

```swift
debugController.add(.yourValue, to: .yourSection, value: "Hello, World!")
```

> ###### Notes
> Make sure that your `id` is unique, as it is used for diffing and identifying the section.
