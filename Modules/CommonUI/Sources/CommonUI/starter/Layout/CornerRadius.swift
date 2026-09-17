import CoreGraphics

/// The shared corner radius scale.
public enum CornerRadius {
    /// 3
    public static let small: CGFloat = 3.0
    /// 4
    public static let half: CGFloat = 4.0
    /// 8
    public static let normal: CGFloat = 8.0
    /// 9
    public static let card: CGFloat = 9.0
    /// 9 for iOS < 26.0, 26 for iOS 26.0+
    public static var listItem: CGFloat {
        if #available(iOS 26.0, *) {
            26.0
        } else {
            9.0
        }
    }

    /// 16
    public static let double: CGFloat = 16.0
}
