---
name: ios-dependency-design
description: How to design and register dependencies in this project — @DependencyClient structs over protocols, liveValue/previewValue/testValue, where a client belongs (Core/Controllers, Core/Networking, app target), scoping sub-clients into reducers, and Sendable rules. Use when adding or refactoring a service, wrapping a system API (keychain, location, notifications, storage), making code testable, or reviewing how a feature reaches the outside world.
---

# Dependency design

Everything a feature needs from the outside world — network, disk, keychain, clock, system
frameworks, third-party SDKs — arrives through **swift-dependencies**. A reducer never instantiates
a service, never touches `URLSession`/`Alamofire`/`UserDefaults` directly, and never reads a
singleton.

## The shape: `@DependencyClient` struct, not a protocol

```swift
@DependencyClient
public struct VersionCheckClient: Sendable {
    public var check: @Sendable () async throws -> VersionStatus
}

extension VersionCheckClient: DependencyKey {
    public static let liveValue = VersionCheckClient(check: { … })
    public static let previewValue = VersionCheckClient(check: { .upToDate })   // keep previews working
}

public extension DependencyValues {
    var versionCheckClient: VersionCheckClient {
        get { self[VersionCheckClient.self] }
        set { self[VersionCheckClient.self] = newValue }
    }
}
```

Rules:

- **Struct of closures, not a protocol + conforming class.** It lets tests and previews override a
  single endpoint without writing a whole mock type.
- Endpoints are `@Sendable`, `async`, and `throws` when they can fail. Keep UI types out of them.
- The whole client is `Sendable`; live implementations hold state in an `actor` or behind a lock,
  never in `var`s on a shared class.
- `@DependencyClient` synthesises an unimplemented `testValue` that fails the test when called — do
  **not** hand-write a "do nothing" `testValue`. An unexpected call should fail loudly.
- Always provide a `previewValue` with plausible stub data. A `#Preview` must work offline.

## Where a client lives

| Kind | Location |
|---|---|
| API endpoints | `Core/Networking` — generated per OpenAPI tag, composed in `APIClient` (see `ios-code-generation`) |
| Long-lived service / system wrapper (auth, location, push, keychain, storage) | `Core/Controllers` |
| Analytics / tracking | the analytics target in `Core` |
| App-only concern (routing helper, app-lifecycle glue) | app target `Dependencies/` |

If two features need it, it does not live in a feature.

## Using a client in a reducer

Scope down to the smallest surface the feature needs, in the `// MARK: Dependencies` block:

```swift
@Dependency(\.apiClient.watchlist) private var apiClient
@Dependency(\.continuousClock) private var clock
@Dependency(\.dismiss) private var dismiss
```

Prefer the built-in dependencies over rolling your own: `continuousClock`, `date`, `uuid`,
`openURL`, `dismiss`, `mainQueue`. Anything non-deterministic — time, randomness, IDs, locale,
device state — **must** come from a dependency, otherwise the feature is untestable.

Inside `.run` closures, re-resolve with a local `@Dependency` rather than capturing the reducer's
stored property when Sendability requires it.

## Loading data

`Toolbox` ships the `LoadingState` reducer and `CommonUI` the matching views. Prefer
`.loadable(state:action:operation:)` over hand-rolling loading/error/empty flags — it handles
reload-while-showing-data, empty detection and error retention for you.

## Overriding

- Tests: `TestStore(…) { $0.versionCheckClient.check = { .updateRequired } }` — override only the
  endpoints the test exercises.
- Previews: rely on `previewValue`, or `withDependencies` / `prepareDependencies` for a one-off.
- App start: `prepareDependencies` in the entry point for environment-driven wiring (base URL, mock
  mode), driven by `Config`/`AppEnvironment` — not `#if`.

## Anti-patterns

- Singletons (`Service.shared`) or global `static var` state reachable from a feature.
- Protocol + `LiveX`/`MockX` class pairs for something that fits in a closure struct.
- A client returning view models or `View`s — clients return domain values.
- Live network or disk work in `previewValue`.
- Adding a third-party SDK to a feature module instead of wrapping it behind a client in `Core`.

## Related

`ios-project-structure` (module boundaries) · `ios-code-generation` (the generated API client is
itself a `@DependencyClient`) · `tca-feature-structure` from the `ios@aaa-marketplace` plugin (how
effects call these clients).
