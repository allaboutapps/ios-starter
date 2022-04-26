import Foundation

public enum Formatters {
    public enum Date {
        public static let isoDate: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter
        }()

        public static let localizedWeek: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale.autoupdatingCurrent
            formatter.setLocalizedDateFormatFromTemplate("EE d MMM")
            return formatter
        }()

        public static let localizedWeekWithYear: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale.autoupdatingCurrent
            formatter.setLocalizedDateFormatFromTemplate("EE d MMM yyyy")
            return formatter
        }()

        public static let dateMedium: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale.autoupdatingCurrent
            formatter.dateStyle = .medium
            return formatter
        }()
        
        public static let apiRendered: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy HH:mm"
            return formatter
        }()
    }
    
    public enum Duration {
        public static let minutesShort: DateComponentsFormatter = {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .short
            formatter.allowedUnits = [.minute]
            formatter.zeroFormattingBehavior = .pad
            
            return formatter
        }()
        
        public static let hourMinuteShort: DateComponentsFormatter = {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .short
            formatter.allowedUnits = [.hour, .minute]
            formatter.zeroFormattingBehavior = .pad
            
            return formatter
        }()
    }
    
    public enum Number {
        public static let percent: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            return formatter
        }()
        
        public static let percentNoFractionDigits: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            formatter.maximumFractionDigits = 0
            return formatter
        }()
        
        public static let integer: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 0
            formatter.minimumFractionDigits = 0
            return formatter
        }()
    }
    
    public enum Currency {
        public static let twoFractionDigits: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            formatter.locale = Locale.current
            return formatter
        }()
    }
    
    public enum Mass {
        public static let short: MassFormatter = {
            let numberFormatter = NumberFormatter()
            numberFormatter.maximumFractionDigits = 0
            
            let formatter = MassFormatter()
            formatter.numberFormatter = numberFormatter
            formatter.unitStyle = .short
            return formatter
        }()
    }
    
    public enum Measurement {
        public static let short: MeasurementFormatter = {
            let formatter = MeasurementFormatter()
            formatter.unitOptions = MeasurementFormatter.UnitOptions.providedUnit
            formatter.unitStyle = .short
            formatter.numberFormatter = Formatters.Number.integer
            
            return formatter
        }()
    }
    
    public enum Length {
        public static let short: LengthFormatter = {
            let numberFormatter = NumberFormatter()
            numberFormatter.maximumFractionDigits = 2
            numberFormatter.minimumFractionDigits = 2
            
            let formatter = LengthFormatter()
            formatter.unitStyle = .short
            formatter.numberFormatter = numberFormatter
            
            return formatter
        }()
        
        public static let shortNoFractionDigits: LengthFormatter = {
            let numberFormatter = NumberFormatter()
            numberFormatter.maximumFractionDigits = 0
            
            let formatter = LengthFormatter()
            formatter.unitStyle = .short
            formatter.numberFormatter = numberFormatter
            
            return formatter
        }()
    }
    
    public enum PersonName {
        public static let regular: PersonNameComponentsFormatter = {
            let formatter = PersonNameComponentsFormatter()
            formatter.style = .long
            return formatter
        }()
    }
}
