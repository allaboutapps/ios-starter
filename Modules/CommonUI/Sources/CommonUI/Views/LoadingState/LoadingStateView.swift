import ComposableArchitecture
import Foundation
import SwiftUI
import Toolbox

public struct LoadingStateView<
    Content: Equatable & Sendable,
    ContentView: View,
    EmptyContentView: View,
    LoadingView: View,
    ErrorView: View
>: View {

    public typealias IsReloading = Bool
    var store: Store<LoadingState<Content>, LoadingAction<Content>>
    let autoLoad: Bool
    let contentView: (Content, IsReloading, Error?) -> ContentView
    let emptyView: () -> EmptyContentView
    let loadingView: () -> LoadingView
    let errorView: (Error) -> ErrorView

    public init(
        store: Store<LoadingState<Content>, LoadingAction<Content>>,
        autoLoad: Bool = true,
        @ContentBuilder loadingView: @escaping () -> LoadingView,
        @ContentBuilder emptyView: @escaping (() -> EmptyContentView) = { EmptyView() },
        @ContentBuilder errorView: @escaping (Error) -> ErrorView,
        @ContentBuilder contentView: @escaping (Content, IsReloading, Error?) -> ContentView
    ) {
        self.store = store
        self.autoLoad = autoLoad
        self.loadingView = loadingView
        self.emptyView = emptyView
        self.errorView = errorView
        self.contentView = contentView
    }

    public var body: some View {
        Group {
            switch store.state {
            case .loading:
                loadingView()
                    .task {
                        if autoLoad {
                            store.send(.loading)
                        }
                    }
                    .transition(.blurReplace)
            case .success(let value, let error, let isReloading):
                if (value as? EmptyExpressible)?.isEmpty == true {
                    emptyView()
                        .transition(.opacity)
                } else {
                    contentView(value, isReloading, error)
                        .transition(.opacity)
                }
            case .failed(let error):
                errorView(error)
                    .transition(.blurReplace)
            }
        }
        .animation(.default, value: store.state)
    }
}
