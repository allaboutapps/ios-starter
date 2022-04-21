// see https://medium.com/swift-programming/uistoryboard-safer-with-enums-protocol-extensions-and-generics-7aad3883b44d

import UIKit

// MARK: StoryboardIdentifiable

public protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension UIViewController: StoryboardIdentifiable {}

public extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

// MARK: UIStoryboard

public extension UIStoryboard {
    /// Instantiates a storyboard given its name.
    convenience init(_ storyboardName: String, bundle: Bundle? = nil) {
        self.init(name: storyboardName, bundle: bundle)
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
