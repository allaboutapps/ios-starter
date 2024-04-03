import Foundation

// MARK: - ISODateFormatStyle

/// Parsing input: any ISO Date (e.g. 2024-04-03T09:57:12.898Z).
/// Formatting output: 2024-04-03T09:57:12.898Z
public struct ISODateFormatStyle: ParseableFormatStyle, ParseStrategy {
    public var parseStrategy = Date.ISO8601FormatStyle()
        .year()
        .month()
        .day()
        .timeZone(separator: .omitted)
        .time(includingFractionalSeconds: true)
        .timeSeparator(.colon)

    public func format(_ value: Date) -> String {
        value.formatted(parseStrategy)
    }

    public func parse(_ value: String) throws -> Date {
        try Date(value, strategy: parseStrategy)
    }
}

public extension FormatStyle where Self == ISODateFormatStyle {
    static var isoDate: ISODateFormatStyle { .init() }
}

public extension ParseStrategy where Self == ISODateFormatStyle {
    static var isoDate: ISODateFormatStyle { .init() }
}

// MARK: - APIDateFormatStyle

/// Parsing input: any API Date (e.g. 03.04.2024 12:04).
/// Formatting output: 03.04.2024, 12:04
public struct APIDateFormatStyle: ParseableFormatStyle, ParseStrategy {
    public var parseStrategy = Date.FormatStyle()
        .day(.twoDigits)
        .month(.twoDigits)
        .year(.extended(minimumLength: 4))
        .hour(.twoDigits(amPM: .omitted))
        .minute(.twoDigits)

    public func format(_ value: Date) -> String {
        value.formatted(parseStrategy)
    }

    public func parse(_ value: String) throws -> Date {
        try Date(value, strategy: parseStrategy)
    }
}

public extension FormatStyle where Self == APIDateFormatStyle {
    static var apiDate: APIDateFormatStyle { .init() }
}

public extension ParseStrategy where Self == APIDateFormatStyle {
    static var apiDate: APIDateFormatStyle { .init() }
}

// MARK: - LocalizedWeekDayFormatStyle

/// Input: any Date (e.g. 3 Apr 2024 at 12:16 PM).
/// Formatting output: Wed, 3 Apr
public struct LocalizedWeekDayFormatStyle: FormatStyle {
    public func format(_ value: Date) -> String {
        value.formatted(
            Date.FormatStyle()
                .weekday(.abbreviated)
                .day(.defaultDigits)
                .month(.abbreviated)
                .locale(.autoupdatingCurrent)
        )
    }
}

public extension FormatStyle where Self == LocalizedWeekDayFormatStyle {
    static var localizedWeekDay: LocalizedWeekDayFormatStyle { .init() }
}

// MARK: - LocalizedWeekdayWithYearFormatStyle

/// Input: any Date (e.g. 3 Apr 2024 at 12:16 PM).
/// Formatting output: Wed, 3 Apr 2024
public struct LocalizedWeekdayWithYearFormatStyle: FormatStyle {
    public func format(_ value: Date) -> String {
        value.formatted(
            Date.FormatStyle()
                .weekday(.abbreviated)
                .day(.defaultDigits)
                .month(.abbreviated)
                .year()
                .locale(.autoupdatingCurrent)
        )
    }
}

public extension FormatStyle where Self == LocalizedWeekdayWithYearFormatStyle {
    static var localizedWeekdayWithYear: LocalizedWeekdayWithYearFormatStyle { .init() }
}

// MARK: - MediumDateFormatStyle

/// Input: any Date (e.g. 3 Apr 2024 at 12:16 PM).
/// Formatting output: 3 Apr 2024
public struct MediumDateFormatStyle: FormatStyle {
    public func format(_ value: Date) -> String {
        value.formatted(date: .abbreviated, time: .omitted)
    }
}

public extension FormatStyle where Self == MediumDateFormatStyle {
    static var medium: MediumDateFormatStyle { .init() }
}

// MARK: - HourMinuteShortFormatStyle

/// Input: any Date Range (e.g. 2 Apr 2024 at 12:21 PM - 3 Apr 2024 at 12:15 PM).
/// Formatting output: 23 hrs, 53 min
public struct HourMinuteShortFormatStyle: FormatStyle {
    public func format(_ value: Range<Date>) -> String {
        let style = Date.ComponentsFormatStyle(
            style: .abbreviated,
            locale: .autoupdatingCurrent,
            calendar: .init(identifier: .gregorian),
            fields: [.hour, .minute]
        )

        return value.formatted(style)
    }
}

public extension FormatStyle where Self == HourMinuteShortFormatStyle {
    static var hourMinuteShort: HourMinuteShortFormatStyle { .init() }
}

// MARK: - CurrencyEuroFormatStyle

/// Input: any Double (e.g. 151.498).
/// Formatting output: € 151,50
public struct CurrencyEuroFormatStyle: FormatStyle {
    public func format(_ value: Double) -> String {
        value.formatted(
            .currency(code: "EUR")
                .precision(.fractionLength(2))
                .locale(.init(identifier: "de-AT"))
                .rounded()
        )
    }
}

public extension FormatStyle where Self == CurrencyEuroFormatStyle {
    static var currencyEuro: CurrencyEuroFormatStyle { .init() }
}