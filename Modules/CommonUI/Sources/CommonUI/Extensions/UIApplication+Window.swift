import UIKit

public extension UIApplication {

    var keyWindow: UIWindow? {
        activeWindowScene?
            .windows
            .first(where: \.isKeyWindow)
    }

    // swiftlint:disable first_where
    var activeWindowScene: UIWindowScene? {
        connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap { $0 as? UIWindowScene }
    }

    var sceneWindows: [UIWindow] {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
    }
}
