// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
  import SwiftUI
#elseif os(iOS)
  import UIKit
  import SwiftUI
#elseif os(tvOS) || os(watchOS)
  import UIKit
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetColorTypeAlias = ColorAsset.Color

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Colors {
  public static let brandPrimary = ColorAsset(name: "brandPrimary")
  public static let error = ColorAsset(name: "error")
  public static let success = ColorAsset(name: "success")
  public static let warning = ColorAsset(name: "warning")
}

public extension UIColor {
	static let brandPrimary = UIColor(named: "brandPrimary", in: BundleToken.bundle, compatibleWith: nil)
	static let error = UIColor(named: "error", in: BundleToken.bundle, compatibleWith: nil)
	static let success = UIColor(named: "success", in: BundleToken.bundle, compatibleWith: nil)
	static let warning = UIColor(named: "warning", in: BundleToken.bundle, compatibleWith: nil)
}

public extension SwiftUI.Color {
	static let brandPrimary = SwiftUI.Color("brandPrimary", bundle: BundleToken.bundle)
	static let error = SwiftUI.Color("error", bundle: BundleToken.bundle)
	static let success = SwiftUI.Color("success", bundle: BundleToken.bundle)
	static let warning = SwiftUI.Color("warning", bundle: BundleToken.bundle)
}

// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class ColorAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  public private(set) lazy var color: Color = {
	guard let color = Color(asset: self) else {
	  fatalError("Unable to load color asset named \(name).")
	}
	return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  public func color(compatibleWith traitCollection: UITraitCollection) -> Color {
	let bundle = BundleToken.bundle
	guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
	  fatalError("Unable to load color asset named \(name).")
	}
	return color
  }
  #endif

  fileprivate init(name: String) {
	self.name = name
  }
}

public extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
	let bundle = BundleToken.bundle
	#if os(iOS) || os(tvOS)
	self.init(named: asset.name, in: bundle, compatibleWith: nil)
	#elseif os(macOS)
	self.init(named: NSColor.Name(asset.name), bundle: bundle)
	#elseif os(watchOS)
	self.init(named: asset.name)
	#endif
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
