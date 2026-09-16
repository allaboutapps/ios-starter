import Foundation

public enum DisplayableErrorAction: String, Sendable {
    case send
    case load
    case generic
}

public enum DisplayableErrorMessageType: String, Sendable {
    case title
    case message
}

public protocol DisplayableError: Sendable {
    var title: String { get }
    var messageLoad: String { get }
    var messageSend: String { get }
    var messageGeneric: String { get }
}

public extension DisplayableError {
    var title: String {
        Strings.globalErrorGenericFallbackTitle
    }

    var messageLoad: String {
        messageGeneric
    }

    var messageSend: String {
        messageGeneric
    }
}

public struct UserFacingError: Error, DisplayableError, Sendable, Equatable, Hashable {

    public let title: String
    public let messageLoad: String
    public let messageSend: String
    public let messageGeneric: String
    public let innerError: Error

    public static func == (lhs: UserFacingError, rhs: UserFacingError) -> Bool {
        lhs.title == rhs.title &&
            lhs.messageLoad == rhs.messageLoad &&
            lhs.messageSend == rhs.messageSend &&
            lhs.messageGeneric == rhs.messageGeneric
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(messageLoad)
        hasher.combine(messageSend)
        hasher.combine(messageGeneric)
    }
}

public extension DisplayableError where Self: Error {
    var userFacingError: UserFacingError {
        UserFacingError(
            title: title,
            messageLoad: messageLoad,
            messageSend: messageSend,
            messageGeneric: messageGeneric,
            innerError: self
        )
    }
}

public extension Error {
    var userFacingError: UserFacingError {
        if let displayableError = self as? DisplayableError & Error {
            displayableError.userFacingError
        } else if let wrapper = NSErrorWrapper(error: self as NSError) {
            wrapper.userFacingError
        } else {
            UserFacingError(
                title: Strings.globalErrorGenericFallbackTitle,
                messageLoad: Strings.globalErrorLoadFallbackMessage,
                messageSend: Strings.globalErrorSendFallbackMessage,
                messageGeneric: Strings.globalErrorGenericFallbackMessage,
                innerError: self
            )
        }
    }
}
