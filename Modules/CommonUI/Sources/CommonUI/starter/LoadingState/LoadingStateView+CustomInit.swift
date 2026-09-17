import ComposableArchitecture
import SFSafeSymbols
import SwiftUI
import Toolbox

public extension LoadingStateView where LoadingView == MaxProgressView, ErrorView == ErrorStateView {

    init(
        store: Store<LoadingState<Content>, LoadingAction<Content>>,
        autoLoad: Bool = true,
        errorRetryAction: (() -> Void)? = nil,
        @ContentBuilder emptyView: @escaping (() -> EmptyContentView) = {
            EmptyStateView(
                Strings.globalEmptyStateTitle,
                symbol: .exclamationmarkCircle
            )
        },
        @ContentBuilder contentView: @escaping (Content, IsReloading, Error?) -> ContentView
    ) {
        self.init(
            store: store,
            autoLoad: autoLoad,
            loadingView: {
                MaxProgressView()
            },
            emptyView: emptyView,
            errorView: { error in
                ErrorStateView(error: error, action: errorRetryAction ?? { store.send(.loading) })
            },
            contentView: contentView
        )
    }
}

public extension LoadingStateView where ErrorView == ErrorStateView {

    init(
        store: Store<LoadingState<Content>, LoadingAction<Content>>,
        autoLoad: Bool = true,
        errorRetryAction: (() -> Void)? = nil,
        @ContentBuilder loadingView: @escaping (() -> LoadingView),
        @ContentBuilder emptyView: @escaping (() -> EmptyContentView) = {
            EmptyStateView(
                Strings.globalEmptyStateTitle,
                symbol: .exclamationmarkCircle
            )
        },
        @ContentBuilder contentView: @escaping (Content, IsReloading, Error?) -> ContentView
    ) {
        self.init(
            store: store,
            autoLoad: autoLoad,
            loadingView: loadingView,
            emptyView: emptyView,
            errorView: { error in
                ErrorStateView(error: error, action: errorRetryAction ?? { store.send(.loading) })
            },
            contentView: contentView
        )
    }
}
