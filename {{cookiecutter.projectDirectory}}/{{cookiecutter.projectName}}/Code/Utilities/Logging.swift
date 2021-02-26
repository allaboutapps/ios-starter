import Foundation
import {{cookiecutter.projectName}}Kit
import Logbook

// MARK: - Global

let log = Logbook.self

// MARK: - Setup

extension AppDelegate {
    func setupLogging(for environment: Environment) {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .none
        dateformatter.timeStyle = .medium
        
        switch environment.buildConfig {
        case .debug:
            let sink = ConsoleLogSink(level: .min(.debug))
            
            sink.format = "> \(LogPlaceholder.category) \(LogPlaceholder.date): \(LogPlaceholder.messages)"
            sink.dateFormatter = dateformatter
            
            log.add(sink: sink)
        case .release:
            log.add(sink: OSLogSink(level: .min(.warning)))
        }
    }
}

// MARK: - Categories

extension LogCategory {
}
