# Strings, assets & analytics codegen

## Localized strings

- Source of truth is `Localizable.strings`, synced with **Texterify**; `./buildStrings` pulls
  translations and runs SwiftGen to produce `Strings.*`.
- **German is the default localization** in most projects — write the German copy first;
  English/other languages come back from Texterify. Check `defaultLocalization` in the owning
  package before assuming.
- Key style: `{feature}_{screen}_{element}`, e.g. `login_form_email_placeholder`.
- **No hardcoded user-facing strings in Swift.** Use `Strings.loginFormEmailPlaceholder`. Debug-only
  text and accessibility identifiers are the only exceptions.
- Plurals and interpolation go through the stringsdict/placeholder mechanism, not string
  concatenation — concatenated sentences cannot be translated correctly.
- Adding a key: add it to the source file, run `./buildStrings`, commit both the strings file and
  the regenerated `Strings.swift`.

`CommonUI` is the exception: it ships its own small `Strings` enum with English fallbacks and no
resource bundle, so the package stays usable on its own. A project overrides any of those by
defining the same key (e.g. `global.error.button.retry`) in its own `Localizable.strings` — the app
bundle is consulted first.

## Assets & colors

SwiftGen also generates `Assets.*` / `Colors.*` from the asset catalogs. Reference the generated
symbols (`Colors.backgroundPrimary`, `Assets.illustrationEmptyState`) — never `Color("name")` or
`UIImage(named:)` with a literal. New colors are added to the catalog with light **and** dark
variants, or to the DesignSystem tokens, then regenerated.

## Analytics

Analytics events and screens are spec-driven: YAML specs (an `analytics-specs/` folder or
submodule) plus SwiftGen stencils (`templates/*.stencil`) generate type-safe `Events.swift` /
`Screens.swift` into `Core`.

```swift
analytics.track(event: .homeTapMarkets())
```

- To add an event: edit the YAML spec, regenerate, then call the generated API. **Never hand-write
  event name constants or string literals** — the spec is shared with the other platforms and with
  the data team, and drifting names break the funnels.
- Event parameters are declared in the spec and become typed arguments of the generated factory.
- Screen tracking goes through the generated `Screens` API, usually from the feature's
  `onAppear`/`onTask`.
