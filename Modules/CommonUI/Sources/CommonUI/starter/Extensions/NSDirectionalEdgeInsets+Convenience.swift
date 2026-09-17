#if canImport(UIKit)

import UIKit

public extension NSDirectionalEdgeInsets {
    init(vertical: CGFloat = .zero, horizontal: CGFloat = .zero) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
    
    init(_ value: CGFloat) {
        self.init(vertical: value, horizontal: value)
    }
    
    init(
        leading: CGFloat = .zero,
        top: CGFloat = .zero,
        trailing: CGFloat = .zero,
        bottom: CGFloat = .zero
    ) {
        self.init(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }
}

#endif
