import Foundation
import SwiftUI

extension LabelStyle where Self == CenterAlignedLabelStyle {

    /// A label style that centres the icon and title in a HStack
    static var centerAlignedLabelStyle: CenterAlignedLabelStyle {
        CenterAlignedLabelStyle()
    }
}

struct CenterAlignedLabelStyle: LabelStyle {

    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: 8) {
            configuration.icon
            configuration.title
        }
    }
}
