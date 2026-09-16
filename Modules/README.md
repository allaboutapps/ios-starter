# Modules

Every module is a standalone Swift package. Packages depend on each other by path
(`.package(path: "../Toolbox")`), so a project consumes exactly the ones it needs.

| Module     | What it holds                                                                   |
| ---------- | ------------------------------------------------------------------------------- |
| `Toolbox`  | Foundation/UIKit helpers and the `LoadingState` reducer, formerly the standalone `allaboutapps/Toolbox` |
| `CommonUI` | Project-agnostic SwiftUI components, the HTML renderer and the `DisplayableError` model                 |

## Building

Each package builds and tests on its own, against an iOS simulator:

```sh
cd Modules/CommonUI
xcodebuild test -scheme CommonUI -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## Adding a module

1. `mkdir Modules/<Name>` and add a `Package.swift` with the module's name as both package and
   product name — CI derives the scheme name from the directory.
2. Add the new module to the `matrix.module` list in `.github/workflows/ci.yml`.
3. Add its `.build` and `.swiftpm` paths to `excluded:` in the repository's `.swiftlint.yml`.
4. Keep dependencies pointing *down*: `CommonUI` may depend on `Toolbox`, never the reverse.

## What does not belong here

Anything project-specific — API clients, design tokens, brand assets, feature flows. Those live in
the forked project. A module earns its place here only once at least two projects want it unchanged.
