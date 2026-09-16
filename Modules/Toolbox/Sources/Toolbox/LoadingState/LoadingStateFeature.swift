import ComposableArchitecture
import Foundation
import OSLog
import SwiftUI

@CasePathable
public enum LoadingAction<Value: Sendable & Equatable>: Sendable {
    case loading
    case receiveLoaded(TaskResult<Value>)
}

public extension Reducer {
    func loadable<Value: Equatable & Sendable>(
        state toLoadableState: WritableKeyPath<State, LoadingState<Value>>,
        action toLoadableAction: CaseKeyPath<Action, LoadingAction<Value>>,
        operation loadOperation: @Sendable @escaping (State) async throws -> Value
    ) -> _LoadingReducer<Self, Value> {
        _LoadingReducer(
            parent: self,
            toLoadableState: toLoadableState,
            toLoadableAction: AnyCasePath(toLoadableAction),
            loadOperation: loadOperation
        )
    }
}

extension WritableKeyPath: @unchecked Sendable {}

extension KeyPath: @unchecked @retroactive Sendable {}

extension Reduce: @unchecked @retroactive Sendable where State: Sendable, Action: Sendable {}

public struct _LoadingReducer<Parent: Reducer, Value: Equatable & Sendable>: Reducer where Parent.Action: Sendable, Parent.State: Sendable {
    let parent: Parent
    let toLoadableState: WritableKeyPath<Parent.State, LoadingState<Value>>
    let toLoadableAction: AnyCasePath<Parent.Action, LoadingAction<Value>>
    let loadOperation: @Sendable (Parent.State) async throws -> Value

    public func reduce(
        into state: inout Parent.State,
        action: Parent.Action
    ) -> Effect<Parent.Action> {
        let parentEffects: Effect<Parent.Action> = parent._reduce(into: &state, action: action)
        let currentState = state[keyPath: toLoadableState]
        var childEffects: Effect<Action> = .none

        if let loadableAction = toLoadableAction.extract(from: action) {
            switch (currentState.value, loadableAction) {
            case (let currentValue, .loading):
                if let currentValue {
                    if let emptyExpressible = currentValue as? EmptyExpressible,
                       emptyExpressible.isEmpty {
                        state[keyPath: toLoadableState] = .loading
                    } else {
                        state[keyPath: toLoadableState] = .success(value: currentValue, error: nil, isReloading: true)
                    }
                } else {
                    state[keyPath: toLoadableState] = .loading
                }

                childEffects = .run { [state, toLoadableAction, loadOperation] send in
                    await send(
                        toLoadableAction.embed(
                            .receiveLoaded(
                                TaskResult { try await loadOperation(state) }
                            ))
                    )
                }
            case (_, .receiveLoaded(.success(let childState))):
                state[keyPath: toLoadableState] = .success(value: childState, error: nil, isReloading: false)
            case (let currentValue, .receiveLoaded(.failure(let error))):
                #if DEBUG
                    Logger.loadingState.error("Loading failed with error:\n\(error)")
                #endif
                if let currentValue {
                    state[keyPath: toLoadableState] = .success(value: currentValue, error: error, isReloading: false)
                } else {
                    state[keyPath: toLoadableState] = .failed(error)
                }

            case (_, .receiveLoaded):
                break
            }
        }

        return parentEffects.concatenate(with: childEffects)
    }
}

extension Logger {

    static let loadingState = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "",
        category: "LoadingState"
    )
}

public protocol EmptyExpressible {
    var isEmpty: Bool { get }
}

extension Optional: EmptyExpressible {
    public var isEmpty: Bool {
        switch self {
        case .none: true
        case .some: false
        }
    }
}

extension Array: EmptyExpressible {}
extension Dictionary: EmptyExpressible {}
