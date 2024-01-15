// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum Strings {
  /// Anmelden
  public static let authLoginButton = Strings.tr("Localizable", "auth_login_button", fallback: "Anmelden")
  /// Login
  public static let authLoginTitle = Strings.tr("Localizable", "auth_login_title", fallback: "Login")
  /// Hello, World!
  public static let exampleText = Strings.tr("Localizable", "example_text", fallback: "Hello, World!")
  /// Example
  public static let exampleTitle = Strings.tr("Localizable", "example_title", fallback: "Example")
  /// Abbrechen
  public static let genericCancel = Strings.tr("Localizable", "generic_cancel", fallback: "Abbrechen")
  /// Nein
  public static let genericNo = Strings.tr("Localizable", "generic_no", fallback: "Nein")
  /// Ok
  public static let genericOk = Strings.tr("Localizable", "generic_ok", fallback: "Ok")
  /// Ja
  public static let genericYes = Strings.tr("Localizable", "generic_yes", fallback: "Ja")
  /// Tab 1
  public static let mainTabFirst = Strings.tr("Localizable", "main_tab_first", fallback: "Tab 1")
  /// Tab 2
  public static let mainTabSecond = Strings.tr("Localizable", "main_tab_second", fallback: "Tab 2")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
