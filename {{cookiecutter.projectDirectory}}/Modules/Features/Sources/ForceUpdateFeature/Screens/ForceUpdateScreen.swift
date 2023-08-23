import Assets
import Foundation
import SwiftUI

struct ForceUpdateScreen: View {

    // MARK: Init

    private let appStoreURL: URL?

    init(appStoreURL: URL?) {
        self.appStoreURL = appStoreURL
    }

    // MARK: Body

    var body: some View {
        ScrollView {
            VStack(spacing: .zero) {
                Image(systemName: "app.badge")
                    .font(.system(size: 90))
                    .padding(.top, 64)
                    .foregroundColor(.brandPrimary)
                VStack(spacing: 20) {
                    Text(Strings.forceUpdateTitle)
                        .font(.largeTitle)
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                    Text(Strings.forceUpdateMessage)
                        .font(.body)
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 48)
                .padding(.bottom, 24)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 32)
        }
        .scrollBounceBehaviorIfAvailable()
        .safeAreaInset(edge: .bottom) {
            Button(
                action: {
                    if let appStoreURL {
                        // open product page of the app in the AppStore
                        UIApplication.shared.open(appStoreURL)
                    } else {
                        // fallback: open AppStore
                        let url = URL(string: "itms-apps://itunes.apple.com/")!
                        UIApplication.shared.open(url)
                    }
                },
                label: {
                    Label(Strings.forceUpdateActionToAppStore, systemImage: "arrowshape.turn.up.right.fill")
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .labelStyle(.centerAlignedLabelStyle)
                }
            )
            .buttonStyle(.borderedProminent)
            .tint(.brandPrimary)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.background)
        }
    }
}

// MARK: - Previews

struct ForceUpdateScreen_Previews: PreviewProvider {

    static var previews: some View {
        ForceUpdateScreen(
            appStoreURL: nil
        )
    }
}
