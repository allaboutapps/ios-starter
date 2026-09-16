---
name: ios-code-generation
description: Generated code in this project — the OpenAPI/Alamofire API client, localized strings (Texterify + SwiftGen), assets, and spec-driven analytics events. Explains what is generated, which script regenerates it, and where hand-written code may live. Use before editing anything under a Generated/ folder, adding an endpoint, model, string, asset, or analytics event, or when a build fails on generated symbols.
---

# Code generation

Large parts of a project built on this starter are generated. One rule governs all of them:

> **Never hand-edit a file under a `Generated/` directory.** Change the source of truth (OpenAPI
> spec, strings/Texterify, analytics YAML, asset catalog), rerun the script, and commit the output.

The scripts wipe those directories on every run, so a hand edit is lost at the next regeneration.
Generated files carry `// swiftlint:disable all` and their directories are excluded in
`.swiftlint.yml` — lint findings there are never yours to fix.

| Generated artefact | Source of truth | Script |
|---|---|---|
| API client + models (`Core/Networking`) | `<project>-api.yaml` (OpenAPI) | `./generateAPI` / `./generateNetworking` |
| `Strings.*` | `Localizable.strings` / Texterify | `./buildStrings` |
| `Assets.*` / `Colors.*` | asset catalogs | `./buildStrings` (SwiftGen step) |
| `Events.swift` / `Screens.swift` | analytics YAML spec | SwiftGen stencils |

All scripts are manual — they are **not** wired into the build. Run them at the repo root and commit
the result in the same change.

> The starter itself ships none of these scripts; they arrive with the project's own `Core` module
> and API spec. Follow whatever the fork already does.

## API client

Generated with the OpenAPITools `openapi-generator` (`swift6` generator, `--library alamofire`) plus
custom mustache templates — **not** Apple's swift-openapi-generator.

```
<repo root>/
├── <project>-api.yaml               # OpenAPI spec, committed
├── generateAPI                      # the ONLY way to regenerate
├── openapi-generator-config.json
├── openapi-swift6-templates/        # custom mustache templates
└── Modules/Core/Sources/Networking/
    ├── API/
    │   ├── Generated/               # one file per OpenAPI tag
    │   └── APIClient.swift          # hand-written composition root
    ├── Models/
    │   ├── Generated/               # generated models
    │   ├── Custom/                  # hand-written value types (PriceValue, LocalTime, …)
    │   └── Extensions/              # hand-written extensions on generated models
    └── Error/APIError.swift
```

The templates make **the generated code itself the dependency**: each OpenAPI tag becomes a
`@DependencyClient` struct of `@Sendable () async throws -> T` closures with a `liveValue` wired to
the shared transport. Hand-written `APIClient.swift` aggregates the tag clients, owns the Alamofire
`Session` and its interceptors (auth/token refresh, logging), and may patch individual generated
closures in `liveValue`.

Type mappings in the generate script keep domain types strong — IDs map to `swift-tagged` types,
formats to hand-written value types in `Models/Custom/`. When adding spec fields with special
formats, extend the mappings rather than post-editing generated models.

Features never see Alamofire. They inject a scoped sub-client and call it inside an effect:

```swift
@Dependency(\.apiClient.watchlist) private var apiClient
…
try await apiClient.getWatchlist()
```

Errors surface as `APIError` and are mapped to `CommonUI`'s `DisplayableError` for presentation.

## Strings, assets, analytics

Full rules — key style, default localization, plurals, analytics specs — in
[references/strings-and-analytics.md](references/strings-and-analytics.md). Short version:

- **Strings** — add the key to the strings source, run `./buildStrings`, use `Strings.<key>`. No
  string literals in views. `CommonUI` ships fallback strings for its own error states, which a
  project overrides by defining the same key in its own `Localizable.strings`.
- **Assets** — add to the asset catalog and regenerate; reference via the generated `Assets.*` /
  `Colors.*` accessors, never by raw name string.
- **Analytics** — add the event or screen to the YAML spec and regenerate. Never hand-write event
  name constants.

## Quick decision guide

- **New endpoint or changed response?** The change starts in the backend spec, not in Swift. Update
  the spec → regenerate → adapt call sites.
- **Behaviour on a generated model?** Add an extension in `Models/Extensions/`, never a stored
  property in the generated file.
- **A type the generator can't express?** Add a value type in `Models/Custom/` and map the OpenAPI
  format to it in the generate script.
- **Build fails on a generated symbol?** Regenerate first; don't patch the generated file.

## Related

`ios-dependency-design` (the generated API is a `@DependencyClient`) · `ios-project-structure`
(where the generated modules sit) · the `swiftui-coder` agent from `ios@aaa-marketplace` (using
`Strings.*`/`Assets.*` in views).
