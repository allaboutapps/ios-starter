# iOS Starter 📱

The shared base for aaa iOS projects. A new project is **cloned from this template** — not forked —
and keeps the starter as a separate remote, so improvements made here can still be merged into
running projects later.

This repository deliberately contains **no Xcode project and no app target** — only the shared
Swift packages under [`Modules/`](Modules/README.md) plus the linting, formatting and CI setup.
Each project brings its own app shell.

## Starting a new project

```sh
git clone https://github.com/allaboutapps/ios-starter.git my-project-ios
cd my-project-ios
scripts/starter-init.sh [<new-origin-url>]
```

`starter-init.sh` deletes the starter's history, starts a fresh one whose initial commit records
which starter commit it came from, and registers the starter as the `ios-starter` remote
(push-disabled). Your project's history is therefore *unrelated* to the starter's — that is the
point of a template, and it is why the merge below needs `--allow-unrelated-histories`.

## Connecting an existing project

A repository that was never based on the starter (it predates it, or was set up by hand) can still
receive starter changes — but it has none of these scripts yet, so the connect step ships with the
`ios@aaa-marketplace` plugin instead:

```
/ios-starter-connect
```

It adds the `ios-starter` remote, merges the starter onto a fresh `adopt-ios-starter` branch, and
resolves the mechanical conflicts (shared config, tooling), leaving the judgement calls for you.
Nothing is committed. The merge brings the scripts below into that project, so from then on it syncs
like any other.

## Updating from the starter

```sh
scripts/starter-compare.sh    # how many commits behind, and which ones
scripts/starter-merge.sh      # merge them into HEAD
```

The merge is left **uncommitted**, and conflicts are left in the working tree on purpose: a project
that customized a file the starter also changed *should* collide there.

Run `/starter-sync` instead of the scripts directly and Claude drives the same flow, then resolves
the mechanical conflicts for you — shared config and tooling get combined, keeping every
project-specific rule and exclusion. Anything where project and starter genuinely disagree (a
same-named module, Swift sources, the Xcode project) is left conflicted with a note on the decision
it needs. Nothing is committed either way; you review and commit.

Both scripts take `IOS_STARTER_TARGET` to aim at something other than `ios-starter/main`:

```sh
IOS_STARTER_TARGET=ios-starter/some-branch scripts/starter-compare.sh   # a branch
IOS_STARTER_TARGET=ios-starter-2026-09-16 scripts/starter-compare.sh    # a tag
IOS_STARTER_TARGET=84d8a2b scripts/starter-compare.sh                   # a commit
```

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

`.claude/` ships the conventions Claude follows in this repo and in every project templated from it.

| Location | Scope | Contents |
| --- | --- | --- |
| `.claude/skills/` | this project | `ios-project-structure`, `ios-dependency-design`, `ios-code-generation` — how *this* module graph, dependency wiring and codegen work; `/starter-sync` to run the sync scripts |
| `ios@aaa-marketplace` | all iOS projects | `tca-feature-structure` skill, `swiftui-coder` and `xcode-build-runner` agents |

`.claude/settings.json` enables the marketplace plugins, so a fresh clone needs no per-machine
setup. The split is deliberate: anything describing *this repository's* layout lives here and is
inherited by projects, which then adapt it as they grow modules. Anything true of iOS work in general
lives in the marketplace, where it is versioned once and shared by every project.

When a project adds a module or changes a convention, update the skill in `.claude/skills/` in the
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
├── scripts/
│   ├── starter-init.sh        # one-time: template clone -> new project repo
│   ├── starter-compare.sh     # what changed in the starter
│   └── starter-merge.sh       # merge starter changes into this project
└── Modules/
    ├── CommonUI/              # project-agnostic SwiftUI components
    └── Toolbox/               # the former allaboutapps/Toolbox package, now vendored here
```
