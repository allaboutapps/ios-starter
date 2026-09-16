---
name: ios-project-structure
description: This project's layout — the local SPM module graph under Modules/, allowed dependency direction, feature folder and file naming, where new code belongs, and the shared tooling (SwiftFormat, SwiftLint, CI). Use when adding files, creating a module or feature, moving code, adding a package dependency, or reviewing whether something sits in the right layer.
---

# Project structure

Stack: **SwiftUI + TCA** (swift-composable-architecture), Swift 6 language mode, local SPM packages.

This skill describes *this repository*. It ships in the iOS starter and is inherited by every
project forked from it — when the project grows a module the starter does not have, extend the
table below rather than inventing a parallel convention.

## Module layout

The app target is a **thin shell** (entry point, configs, assets). Everything else lives in local
SPM packages under `Modules/`, each with its own `Package.swift`, wired by relative path
(`.package(path: "../Toolbox")`).

What the starter ships:

```
Modules/
├── Toolbox/     # Foundation/UIKit helpers + the LoadingState reducer. Depends on nothing but TCA.
└── CommonUI/    # SwiftUI components, HTML renderer, loading views, DisplayableError, Padding scale.
```

What a project typically adds:

```
Modules/
├── Core/        # Networking (generated API client), Utilities (Config, extensions), Controllers, Analytics
├── DesignSystem/# brand tokens/atoms/molecules mirroring Figma — no TCA, no Core dependency
└── Features/    # one target per feature domain
```

The dependency direction is strictly one-way:

```
App / Features  ──►  CommonUI  ──►  Toolbox
                        └───────►  Core, DesignSystem
```

Never introduce an upward or sideways edge — `Toolbox` importing `CommonUI`, `DesignSystem`
importing `Core`, one leaf feature importing another. If two features need to share something, it
moves *down* into `CommonUI` or `Core`.

**This repo has no Xcode project and no app target on purpose.** The starter is packages plus
tooling; the fork creates its own project. Don't add an `.xcodeproj` here.

## Where new code goes

| What you're adding | Where |
|---|---|
| Screen, reducer, feature-private view | `Features/<Name>/` (see below) |
| View or modifier reused by ≥ 2 features | `CommonUI` (own folder + `#Preview`) |
| Generic Foundation/UIKit helper, no SwiftUI | `Toolbox` |
| Design token, atom, molecule | `DesignSystem` |
| Long-lived service / system wrapper | `Core/Controllers` as a dependency client (see `ios-dependency-design`) |
| API call, model extension | `Core/Networking` — never inside a feature |
| Formatter, extension, `Config` flag | `Core/Utilities` |

Nothing project-specific belongs in `Modules/` of the starter itself — no brand colors, API models
or feature flows. A module earns a place there only once two projects want it unchanged.

## Feature folder & naming

One folder per screen/flow:

```
FeatureName/
├── FeatureNameFeature.swift         # @Reducer
├── FeatureNameScreen.swift          # SwiftUI view (@ViewAction, @Bindable var store)
├── FeatureNameScreen+Sheets.swift   # optional: navigation modifiers
├── Subviews/                        # feature-private views (plain names, e.g. HomeTickerView)
├── Helpers/                         # feature-private types/providers
└── ChildFlowName/                   # nested child features as subfolders
```

Naming is strict: reducer = `<Name>Feature`, view = `<Name>Screen`, navigation wrapper =
`<Name>NavigationFeature`. Feature-private views keep plain names (`HomeTickerView`), not the
`Screen` suffix.

## Spacing and layout

Use `CommonUI`'s `Padding` scale instead of literal numbers — `.padding(.double)`,
`VStack(spacing: .single)`, `EdgeInsets(horizontal: .double, vertical: .single)`. `CornerRadius`
holds the matching radius steps. A raw `.padding(16)` in a review is a finding.

## Dependencies

Current external dependencies: swift-composable-architecture, SFSafeSymbols, swift-async-algorithms.
A project adds swift-dependencies, swift-tagged (typed IDs), Alamofire, KeychainAccess, Kingfisher
as needed.

**Don't add a new dependency without asking.** Most needs are already covered by `Toolbox` /
`CommonUI`. A third-party SDK is wrapped behind a dependency client in `Core`, never imported
directly by a feature.

## Tooling

- **SwiftFormat** — root `.swiftformat` is authoritative (4-space indent, `--self remove`,
  alphabetical imports, `--marktypes always`, acronyms `ID,URL,UUID`). Run it before committing;
  don't hand-format against it. `.swift-version` pins the language version it assumes.
- **SwiftLint** — root `.swiftlint.yml`. CI runs `swiftlint lint --strict`, so **warnings fail the
  build** and the repo is expected to stay at zero violations. Custom house rules are real
  conventions, not noise: `Image(systemName:)` is banned in favour of SFSafeSymbols'
  `systemSymbol:`.
- **CI** (`.github/workflows/ci.yml`) builds and tests every module in `Modules/` on a simulator it
  resolves at runtime, and runs both linters. Adding a module means adding it to the `matrix.module`
  list and to the `excluded:` paths in `.swiftlint.yml`.
- Packages are iOS-only, so they build via `xcodebuild` against a simulator destination, not
  `swift build`.

Read [references/tooling.md](references/tooling.md) before editing project settings, formatting
rules or environment configuration.

## Related

`ios-dependency-design` (how features reach the outside world) · `ios-code-generation` (generated
API client, strings, assets) · `tca-feature-structure`, the `swiftui-coder` agent and the
`xcode-build-runner` agent from the `ios@aaa-marketplace` plugin.
