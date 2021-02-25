import Foundation
import Logbook

// MARK: - Setup

extension AppDelegate {
    func setupLogging() {
        Logbook.add(sink: ConsoleLogSink(level: .min(.debug)))
    }
}

// MARK: - Categories

extension LogCategory {
}
