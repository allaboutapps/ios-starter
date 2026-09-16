import SFSafeSymbols
import SwiftUI

/// Full-width error state with an optional retry action, driven by `Error.userFacingError`.
public struct ErrorStateView: View {
    private let error: Error
    private let retry: (() -> Void)?

    public init(error: Error, action: (() -> Void)?) {
        self.error = error
        retry = action
    }

    public init(error: Error, action: (() async -> Void)?) {
        self.error = error
        retry = action.map { action in
            { Task { await action() } }
        }
    }

    public var body: some View {
        ContentUnavailableView {
            Label(
                error.userFacingError.title,
                systemSymbol: .xCircleFill
            )
        } description: {
            Text(error.userFacingError.messageLoad)

            if let retry {
                Button(action: retry) {
                    Label(
                        Strings.globalErrorButtonRetry,
                        systemSymbol: .arrowClockwise
                    )
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, .double)
            }
        }
        .listRowBackground(Color.clear)
    }
}

#Preview {
    ErrorStateView(error: URLError(.notConnectedToInternet), action: {})
}
