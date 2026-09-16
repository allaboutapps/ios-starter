import Foundation

struct NSErrorWrapper: Error, DisplayableError {
    private let error: NSError
    let messageGeneric: String

    init?(error: NSError) {
        let urlErrorCode = URLError.Code(rawValue: error.code)
        guard Self.presentableURLErrorCodes.contains(urlErrorCode)
        else {
            return nil
        }

        self.error = error
        messageGeneric = error.localizedDescription
    }

    /// ErrorCodes where default system errorDescription will be shown to the user without our own localization
    private static let presentableURLErrorCodes = Set<URLError.Code>(
        [
            .notConnectedToInternet,
            .internationalRoamingOff,
            .cannotFindHost,
            .cannotConnectToHost,
            .dataNotAllowed,
            .secureConnectionFailed,
        ]
    )
}
