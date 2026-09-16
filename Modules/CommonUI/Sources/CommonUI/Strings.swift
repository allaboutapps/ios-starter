import Foundation

/// Fallback strings used by `CommonUI`'s error presentation.
///
/// The package ships no string resources of its own. A project overrides any of these by defining
/// the same key in its own `Localizable.strings`; the English text here is used only when the app
/// bundle does not define the key.
public enum Strings {
    public static let globalErrorGenericFallbackTitle = localized(
        "global.error.generic.fallback.title",
        default: "Something went wrong"
    )

    public static let globalErrorGenericFallbackMessage = localized(
        "global.error.generic.fallback.message",
        default: "Please try again later."
    )

    public static let globalErrorLoadFallbackMessage = localized(
        "global.error.load.fallback.message",
        default: "The content could not be loaded. Please try again later."
    )

    public static let globalErrorSendFallbackMessage = localized(
        "global.error.send.fallback.message",
        default: "Your data could not be sent. Please try again later."
    )

    public static let globalErrorButtonRetry = localized(
        "global.error.button.retry",
        default: "Try again"
    )

    public static let globalEmptyStateTitle = localized(
        "global.empty.state.title",
        default: "Nothing here yet"
    )

    public static let urlParsingErrorNotAUrlMessage = localized(
        "url.parsing.error.not.a.url.message",
        default: "This link is invalid and cannot be opened."
    )

    private static func localized(_ key: String, default value: String) -> String {
        Bundle.main.localizedString(forKey: key, value: value, table: nil)
    }
}
