import ComposableArchitecture
import SFSafeSymbols
import SwiftUI
import Toolbox

public extension LoadingStateView where LoadingView == InlineLoadingStateView, ErrorView == InlineErrorBox, EmptyContentView == InlineEmptyView {

    static func inlineLoadingState(
        store: Store<LoadingState<Content>, LoadingAction<Content>>,
        autoLoad: Bool = false,
        @ContentBuilder contentView: @escaping (Content, IsReloading, Error?) -> ContentView
    ) -> LoadingStateView {
        LoadingStateView(
            store: store,
            autoLoad: autoLoad,
            loadingView: {
                InlineLoadingStateView()
            },
            emptyView: {
                InlineEmptyView(
                    systemSymbol: .exclamationmarkCircle,
                    description: Strings.globalEmptyStateTitle
                )
            },
            errorView: {
                InlineErrorBox(error: $0, errorRetryAction: { store.send(.loading) })
            },
            contentView: contentView
        )
    }
}

public struct InlineLoadingStateView: View {

    public init() {}
    @State var show: Bool = false

    public var body: some View {
        HStack {
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
    }
}

public struct InlineEmptyView: View {

    private let systemSymbol: SFSymbol
    private let title: String?
    private let description: String

    public init(
        systemSymbol: SFSymbol,
        title: String? = nil,
        description: String
    ) {
        self.systemSymbol = systemSymbol
        self.title = title
        self.description = description
    }

    public var body: some View {
        VStack(spacing: 24) {
            Image(systemSymbol: systemSymbol)
                .font(.system(size: 45, weight: .thin))
                .foregroundColor(Color.secondary)

            if let title {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color.primary)
                    .multilineTextAlignment(.center)
            }

            Text(description)
                .font(.subheadline)
                .foregroundColor(Color.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.quadruple)
        .frame(maxWidth: .infinity)
    }
}

public struct InlineErrorView: View {

    public enum ButtonMode {
        case synchronous(() -> Void)
        case asynchronous(() async -> Void)

        public init(action: @escaping () -> Void) {
            self = .synchronous(action)
        }

        public init(action: @escaping () async -> Void) {
            self = .asynchronous(action)
        }
    }

    private let error: Error
    private let mode: ButtonMode?

    public init(error: Error, action: (() -> Void)?) {
        self.error = error
        if let action {
            mode = .synchronous(action)
        } else {
            mode = nil
        }
    }

    public init(error: Error, action: (() async -> Void)?) {
        self.error = error
        if let action {
            mode = .asynchronous(action)
        } else {
            mode = nil
        }
    }

    public var body: some View {
        VStack(spacing: 24) {
            Image(systemSymbol: .exclamationmarkCircle)
                .font(.system(size: 45, weight: .thin))
                .foregroundColor(Color.secondary)

            Text(error.userFacingError.messageLoad)
                .font(.headline)
                .foregroundColor(Color.primary)
                .multilineTextAlignment(.center)

            switch mode {
            case .synchronous(let action):
                Button(Strings.globalErrorButtonRetry) {
                    action()
                }
                .buttonStyle(.borderless)
            case .asynchronous(let action):
                AsyncButton(action: action) {
                    Text(Strings.globalErrorButtonRetry)
                }
                .buttonStyle(.borderless)
            case .none:
                EmptyView()
            }
        }
        .padding(.quadruple)
        .frame(maxWidth: .infinity)
        .listRowBackground(Color.clear)
    }
}

public struct InlineErrorBox: View {

    let error: UserFacingError
    let mode: ButtonMode

    public init(error: some Error, errorRetryAction: @escaping () -> Void) {
        self.error = error.userFacingError
        mode = .synchronous(errorRetryAction)
    }

    public init(error: some Error, errorRetryAction: @escaping () async -> Void) {
        self.error = error.userFacingError
        mode = .asynchronous(errorRetryAction)
    }

    public var body: some View {
        errorView
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
    }

    @ViewBuilder
    private var errorView: some View {
        switch mode {
        case .synchronous(let action):
            InlineErrorView(error: error, action: action)
        case .asynchronous(let action):
            InlineErrorView(error: error, action: action)
        }
    }
}
