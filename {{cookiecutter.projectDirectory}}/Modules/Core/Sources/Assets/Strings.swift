// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum Strings {
  /// Anmelden
  public static let authLoginButton = Strings.tr("Localizable", "auth_login_button")
  /// Login
  public static let authLoginTitle = Strings.tr("Localizable", "auth_login_title")
  /// Hello, World!
  public static let exampleText = Strings.tr("Localizable", "example_text")
  /// Example
  public static let exampleTitle = Strings.tr("Localizable", "example_title")
  /// Abbrechen
  public static let genericCancel = Strings.tr("Localizable", "generic_cancel")
  /// Nein
  public static let genericNo = Strings.tr("Localizable", "generic_no")
  /// Ok
  public static let genericOk = Strings.tr("Localizable", "generic_ok")
  /// Ja
  public static let genericYes = Strings.tr("Localizable", "generic_yes")
  /// Tab 1
  public static let mainTabFirst = Strings.tr("Localizable", "main_tab_first")
  /// Tab 2
  public static let mainTabSecond = Strings.tr("Localizable", "main_tab_second")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
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
