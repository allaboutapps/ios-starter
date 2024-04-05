import Foundation

public enum Decoders {
    public static let standardJSON: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(Decoders.decodeDate)
        return decoder
    }()

    public static func decodeDate(decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)

        if let value = try? Date(raw, strategy: .isoDate) {
            return value
        }

        if let value = try? Date(raw, strategy: .apiDate) {
            return value
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Couldn't decode Date from \(raw)."
            )
        }
    }
}