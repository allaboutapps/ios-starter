public enum URLParsingError: Error, DisplayableError {
    case notAValidURL

    public var messageGeneric: String {
        Strings.urlParsingErrorNotAUrlMessage
    }
}
