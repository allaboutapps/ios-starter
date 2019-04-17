import UIKit
import ReactiveSwift
import Result

public extension Signal.Observer {
    
    func sendResult(_ value: Value, error: Error? = nil) {
        if error == nil {
            send(value: value)
            sendCompleted()
        } else if error != nil {
            send(error: error!)
        } else {
            sendCompleted()
        }
    }
}

public extension Signal {
    
    func ignoreError(replacement: Signal<Value, NoError>.Event = .completed) -> Signal<Value, NoError> {
        return Signal<Value, NoError> { (observer, lifetime) in
            lifetime += self.observe { (event) in
                switch event {
                case let .value(value):
                    observer.send(value: value)
                case .failed:
                    observer.send(replacement)
                case .completed:
                    observer.sendCompleted()
                case .interrupted:
                    observer.sendInterrupted()
                }
            }
        }
    }
}

public extension SignalProducer {
    
    func ignoreValue() -> SignalProducer<Void, Error> {
        return map { _ in () }
    }
    
    func mapToOptional() -> SignalProducer<Value?, Error> {
        return map { Optional($0) }
    }
    
    func ignoreError(replacement: Signal<Value, NoError>.Event = .completed) -> SignalProducer<Value, NoError> {
        return lift { $0.ignoreError(replacement: replacement) }
    }
}

public extension SignalProducer {
    
    func bindToErrorAlert(_ viewController: UIViewController) -> SignalProducer<Value, Error> {
        return on(failed: { error in
            DispatchQueue.main.async {
                let message = error.localizedDescription
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                viewController.present(alertController, animated: true, completion: nil)
            }
        })
    }
}

public extension ActionError {
    
    func unwrap() -> Swift.Error {
        switch self {
        case .producerFailed(let error):
            return error
        case .disabled:
            return self
        }
    }
    
    var localizedDescription: String {
        return unwrap().localizedDescription
    }
}
