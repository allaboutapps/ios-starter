# iOS Starter 📱

The shared base for aaa iOS projects. A new project forks this repository, so improvements made
here can be pulled into running projects later.

This repository deliberately contains **no Xcode project and no app target** — only the shared
Swift packages under [`Modules/`](Modules/README.md) plus the linting, formatting and CI setup.
Each project brings its own app shell.

## Modules

| Module                              | What it holds                                                           |
| ----------------------------------- | ----------------------------------------------------------------------- |
| [`Toolbox`](Modules/Toolbox)        | Foundation/UIKit helpers and the `LoadingState` reducer                  |
| [`CommonUI`](Modules/CommonUI)      | SwiftUI components, HTML renderer, loading views, `DisplayableError`     |

Add the ones you need to your project as local package dependencies — drag `Modules/CommonUI` into
the Xcode project, or reference it from `project.yml` if you use XcodeGen.

## Building and testing

The packages are iOS-only, so they build through `xcodebuild` against a simulator rather than with
`swift build`:

```sh
cd Modules/CommonUI
xcodebuild test -scheme CommonUI -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

CI runs the same for every module, picking an available simulator automatically.

## Claude Code

`.claude/` ships the conventions Claude follows in this repo and in every project forked from it.

| Location | Scope | Contents |
| --- | --- | --- |
| `.claude/skills/` | this project | `ios-project-structure`, `ios-dependency-design`, `ios-code-generation` — how *this* module graph, dependency wiring and codegen work |
| `ios@aaa-marketplace` | all iOS projects | `tca-feature-structure` skill, `swiftui-coder` and `xcode-build-runner` agents |

`.claude/settings.json` enables the marketplace plugins, so a fresh clone needs no per-machine
setup. The split is deliberate: anything describing *this repository's* layout lives here and is
inherited by forks, which then adapt it as they grow modules. Anything true of iOS work in general
lives in the marketplace, where it is versioned once and shared by every project.

When a fork adds a module or changes a convention, update the skill in `.claude/skills/` in the
same change — a stale skill is worse than no skill.

## Tooling

```sh
brew install swiftlint swiftformat
```

Both run in CI and are expected to stay at zero violations:

```sh
swiftlint lint --strict
swiftformat --lint .
```

Xcode 26 or newer. The modules target iOS 18 (`CommonUI`) and iOS 16 (`Toolbox`).

## Repository layout

```
.
├── .claude/
│   ├── settings.json          # enables the aaa-marketplace plugins
│   └── skills/                # project-specific conventions (structure, dependencies, codegen)
├── .github/workflows/ci.yml   # builds + tests the modules, lints the sources
├── .swift-version             # Swift version for SwiftFormat
├── .swiftformat               # shared SwiftFormat rules
├── .swiftlint.yml             # shared SwiftLint rules
└── Modules/
    ├── CommonUI/              # project-agnostic SwiftUI components
    └── Toolbox/               # the former allaboutapps/Toolbox package, now vendored here
```
