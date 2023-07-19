import Assets
import Toolbox
import UIKit

public enum Appearance {

    public static func setup() {
        UINavigationBar.appearance().tintColor = .systemOrange
        UITabBar.appearance().tintColor = .systemOrange
    }
}

// MARK: - Padding

public extension Style {

    enum Padding {
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

public extension Style {

    enum CornerRadius {
        /// 3
        static let small: CGFloat = 3.0
        /// 5
        static let normal: CGFloat = 5.0
        /// 10
        static let double: CGFloat = 10.0
    }
}
