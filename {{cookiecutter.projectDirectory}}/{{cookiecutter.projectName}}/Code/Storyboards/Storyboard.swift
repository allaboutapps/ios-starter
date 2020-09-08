// see https://medium.com/swift-programming/uistoryboard-safer-with-enums-protocol-extensions-and-generics-7aad3883b44d

import UIKit

enum Storyboard: String {
    case launchScreen = "LaunchScreen"
    /// ... your storyboard names
}

// MARK: StoryboardIdentifiable

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension UIViewController: StoryboardIdentifiable {}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

// MARK: UIStoryboard

extension UIStoryboard {
    /// Instantiates a storyboard given its identifier.
    convenience init(_ storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.rawValue, bundle: bundle)
    }

    /// Instantiates a typed view controller:
    /// ```
    /// let vc: SplashViewController = UIStoryboard(.Misc).instantiateViewController()
    /// ```
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) in storyboard \(self)")
        }

        return viewController
    }
    
    /// Instantiates a typed view controller:
    /// ```
    /// let vc = UIStoryboard(.Misc).instantiateViewController(SplashViewController)
    /// ```
    func instantiateViewController<T: UIViewController>(_ type: T.Type) -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: type.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(type.storyboardIdentifier) in storyboard \(self)")
        }
        
        return viewController
    }
}
