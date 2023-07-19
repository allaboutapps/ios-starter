import Foundation
import SwiftUI

extension View {

    func scrollBounceBehaviorIfAvailable() -> some View {
        if #available(iOS 16.4, *) {
            return self
                .scrollBounceBehavior(.basedOnSize)
        } else {
            return self
        }
    }
}
