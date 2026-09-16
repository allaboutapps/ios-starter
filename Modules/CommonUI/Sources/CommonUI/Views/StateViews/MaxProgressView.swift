import SwiftUI

public struct MaxProgressView: View {
    public init() {}
    @State var show: Bool = false
    public var body: some View {
        VStack {
            Spacer()
            if show {
                ProgressView()
            }
            Spacer()
        }
        .onAppear {
            withAnimation {
                show = true
            }
        }
        .onDisappear {
            show = false
        }
        .frame(maxWidth: .infinity)
    }
}
