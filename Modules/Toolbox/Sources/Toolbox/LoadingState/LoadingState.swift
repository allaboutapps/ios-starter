import ComposableArchitecture
import Foundation

public protocol LoadingStateContent {}

@ObservableState
public enum LoadingState<Value: Equatable & Sendable>: Sendable {
    case loading
    case success(value: Value, error: Error?, isReloading: Bool)
    case failed(Error)

    public var isSuccess: Bool {
        if case .success = self {
            true
        } else {
            false
        }
    }

    public var isLoading: Bool {
        if case .loading = self {
            true
        } else {
            false
        }
    }

    public var value: Value? {
        get {
            if case .success(let value, _, _) = self {
                value
            } else {
                nil
            }
        } set {
            guard let value = newValue else {
                return
            }
            self = .success(value: value, error: nil, isReloading: false)
        }
    }

    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> T? {
        get {
            value?[keyPath: keyPath]
        }
        set {
            guard let newValue else { return }
            value?[keyPath: keyPath] = newValue
        }
    }
}

extension LoadingState: Equatable {
    public static func == (lhs: LoadingState<Value>, rhs: LoadingState<Value>) -> Bool {
        switch (lhs, rhs) {
        case (.failed, .failed),
             (.loading, .loading):
            true
        case (.success(let lhsValue, let lhsError, let lhsIsReloading), .success(let rhsValue, let rhsError, let rhsIsReloading)):
            lhsValue == rhsValue
                && (lhsError != nil) == (rhsError != nil)
                && lhsIsReloading == rhsIsReloading
        default:
            false
        }
    }
}
