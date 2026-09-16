# CommonUI

Project-agnostic SwiftUI building blocks. Everything here works without knowing anything about a
specific app — no brand colors, no API models, no feature flows. Those belong in the project.

Depends on [`Toolbox`](../Toolbox) (for `LoadingState`), ComposableArchitecture and
[SFSafeSymbols](https://github.com/SFSafeSymbols/SFSafeSymbols).

## Layout

`Padding` is an enum of the shared spacing steps (`.quarter` 2, `.half` 4, `.single` 8, `.double`
16, `.triple` 24, `.quadruple` 32) with overloads so it reads naturally at the call site:

```swift
VStack(spacing: .double) { … }
    .padding(.horizontal, .single)
```

It also supports arithmetic (`.single + .half`) and `EdgeInsets(all:)` / `EdgeInsets(horizontal:vertical:)`.
`CornerRadius` holds the matching radius scale, including `.listItem` which adapts on iOS 26.

## Loading state

The views for `Toolbox`'s `LoadingState` reducer. `LoadingStateView` renders loading, success,
error and empty from one store, and `InlineLoadingStateView` is the compact list-row variant.
`LoadingStateView+CustomInit` provides the defaulted initializers that cover the common case.

## Error presentation

`DisplayableError` turns any `Error` into a `UserFacingError` with a title and a message per context
(`messageLoad`, `messageSend`, `messageGeneric`). Conform your own error types to it; everything
else falls back to the built-in strings, and common `URLError`s surface the system message.

```swift
catch {
    alertMessage = error.userFacingError.messageLoad
}
```

`ErrorStateView` renders that directly, with an optional retry action.

The package ships no string resources. A project overrides any fallback string by defining the same
key (e.g. `global.error.button.retry`) in its own `Localizable.strings` — see `Strings.swift`.

## HTML

`HTMLView` renders an HTML string as native SwiftUI text, without a web view. It handles headings,
paragraphs, `ul`/`ol` lists, links, `b`/`strong`/`i`/`u`, `sub`/`sup`, `br`, HTML entities and
custom inline tags. Parsing happens off the first render, so long documents do not block the UI.

```swift
HTMLView(htmlString: html, onLinkTap: { url in openURL(url) })
    .htmlStyle([
        "h1": .init(font: .largeTitle, color: .accentColor),
        "p": .init(font: .body, color: .primary),
    ])
```

`String.cleanUpHTML()` normalizes loose input (wraps bare text in `<p>`, turns `<hr>` into breaks).
There is no table or image support.

## Buttons

`AsyncButton` runs an async action, disabling itself while it runs and swapping its label for a
progress view once the action outlives `progressViewDelay` (150 ms by default), so fast actions do
not flash a spinner.

```swift
AsyncButton("Save") { await save() }
```

## Other views and modifiers

`EmptyStateView` and `MaxProgressView` for empty and loading states, `ConditionalStack` and
`DynamicHStack` (switches axis past a Dynamic Type size). `plainListRow()` strips list row chrome,
`onShake(perform:)` fires on the shake gesture, and `debugBorder()` / `debugBackground()` are
layout debugging aids.

## Extensions

`String.uppercasedWithoutSpaces()`, and `UIApplication.keyWindow` / `.activeWindowScene` /
`.sceneWindows` for reaching the active scene's windows.
