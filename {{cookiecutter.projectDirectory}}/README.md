# {{ cookiecutter.projectName }}

### ForceUpdate

The project comes with the ability to show a blocker screen, if needed. This blocker screen tells the user to update their app.

Enable the feature in `Core.Utilities.Config.ForceUpdate.enabled`:

```swift
public enum ForceUpdate {

    /// feature flag that determines if the force update feature is enabled
    public static let enabled: Bool = true

    /// url of the statically hosted version file, used by force update feature
    public static let publicVersionURL = URL(string: "https://public.allaboutapps.at/config/test/version.json")!
}
```
