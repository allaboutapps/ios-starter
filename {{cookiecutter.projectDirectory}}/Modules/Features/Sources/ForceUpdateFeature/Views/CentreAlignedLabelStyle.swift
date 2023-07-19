import Foundation
import SwiftUI

extension LabelStyle where Self == CentreAlignedLabelStyle {

    /// A label style that centres the icon and title in a HStack
    static var centreAlignedLabelStyle: CentreAlignedLabelStyle {
        CentreAlignedLabelStyle()
    }
}

struct CentreAlignedLabelStyle: LabelStyle {

    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: 8) {
            configuration.icon
            configuration.title
        }
    }
}
