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

#### Disable feature

By default, it is enabled. However, it can be disabled in `Core.Utilities.Config.Debug.enabled`:

[DebugView GitHub](https://github.com/allaboutapps/force-update-ios)