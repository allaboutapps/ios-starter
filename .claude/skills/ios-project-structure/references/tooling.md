# Tooling, project files & environments

## SwiftFormat

Root `.swiftformat` is authoritative. House settings: 4-space indent, `--self remove`, alphabetical
imports, `--marktypes always` (this is why every type carries `// MARK:` section banners), acronyms
`ID,URL,UUID`. `.swift-version` pins the language version it formats against.

Run SwiftFormat before committing; don't hand-format against it, and don't add per-file
`// swiftformat:disable` unless the file is generated — with one exception: disable a *specific*
rule when it changes behaviour. For example `redundantInit` rewrites `T.init("x")` to `T("x")`,
which can silently pick a different overload; the fix is a scoped
`// swiftformat:disable redundantInit` with a comment saying why, not reformatting the call.

## SwiftLint

Root `.swiftlint.yml`. CI runs `swiftlint lint --strict`, so **warnings fail the build** and the
repo is expected to stay at zero violations. In a project that also runs it as a post-compile build
phase, violations surface in the Xcode build log.

- Generated code is excluded — **never** edit files under `Generated/` to satisfy lint.
- Custom house rules are real conventions, not noise: `Image(systemName:)` is banned in favour of
  SFSafeSymbols' `systemSymbol:`.
- Adding a module means adding its `.build` and `.swiftpm` paths to `excluded:`.

## Project file

**The starter ships no `.xcodeproj` and no app target** — it is packages plus tooling, and
`*.xcodeproj` is gitignored. Each project creates its own app shell.

Once a project has one, that committed `.xcodeproj` is the source of truth (no XcodeGen/Tuist unless
the project chose it). Add, move and rename files through Xcode or the Xcode MCP (`XcodeWrite`,
`XcodeMV`, `XcodeRM`) so the pbxproj stays consistent — writing a `.swift` file to disk with a plain
editor leaves it out of the target. After a merge conflict in the pbxproj, verify the target
membership of touched files.

Files inside `Modules/*/Sources` need no pbxproj bookkeeping: SPM globs the directory.

## Environments & configuration

- Build configurations and schemes are driven by xcconfigs in `SupportingFiles/Configurations/`,
  with a per-environment `GoogleService-Info` plist.
- Runtime branching goes through `Config` / `AppEnvironment` in `Core/Utilities`. Add a value there
  and read it; never scatter `#if DEBUG` or env checks through feature code.
- Secrets and endpoints belong in the xcconfig / `Config` layer, not hardcoded in Swift.

## Building

The packages are iOS-only, so they build via `xcodebuild` against a simulator destination, not
`swift build`:

```sh
cd Modules/CommonUI
xcodebuild test -scheme CommonUI -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

Device names and runtimes differ per machine, and `name=…,OS=latest` fails whenever the newest
runtime does not ship that exact device — resolve a concrete udid from `xcrun simctl list devices
available` instead of guessing a name. CI (`.github/workflows/ci.yml`) does exactly that, and runs
one matrix job per module.
