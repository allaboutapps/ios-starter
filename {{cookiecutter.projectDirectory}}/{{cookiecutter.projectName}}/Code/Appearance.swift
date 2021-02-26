import Toolbox
import UIKit

/// Defines the global appearance for the application.
struct Appearance {
    /// Sets the global appearance for the application.
    /// Call this method early in the application's setup, i.e. in `applicationDidFinishLaunching:`
    static func setup() {
        UINavigationBar.appearance().barTintColor = .red
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}

// MARK: - Padding

extension Style {
    struct Padding {
        /// 4
        static let half: CGFloat = 4.0
        /// 8
        static let single: CGFloat = 8.0
        /// 16
        static let double: CGFloat = 16.0
        /// 24
        static let triple: CGFloat = 24.0
    }
}

// MARK: - CornerRadius

extension Style {
    struct CornerRadius {
        /// 3
        static let small: CGFloat = 3.0
        /// 5
        static let normal: CGFloat = 5.0
        /// 10
        static let double: CGFloat = 10.0
    }
}
