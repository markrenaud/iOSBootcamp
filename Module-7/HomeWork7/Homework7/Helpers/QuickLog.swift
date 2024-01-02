//
//  QuickLog.swift
//  Created by Mark Renaud (2023).
//

import Foundation
import OSLog

private extension Logger {
    private static let bundleID = Bundle.main.bundleIdentifier ?? "app.undefined"
    /// A logger for UI related messages
    static let ui = Logger(subsystem: bundleID, category: "ui")
    /// A logger for Model related messages
    static let model = Logger(subsystem: bundleID, category: "model")
}

/// Some syntactical sugar to quickly write to Unified Logging System
enum QuickLog {
    /// A logger for UI related messages
    case ui
    /// A logger for Model related messages
    case model

    private var logger: Logger {
        switch self {
        case .ui:
            Logger.ui
        case .model:
            Logger.model
        }
    }

    /// Logs a message at at the `debug` level in the unified logging system.
    func debug(_ message: String) { logger.debug("\(message)") }
    /// Logs a message at at the `info` level in the unified logging system.
    func info(_ message: String) { logger.info("\(message)") }
    /// Logs a message at at the `error` level in the unified logging system.
    /// `warning`log messages are an alias to `error` and write at this level.
    func error(_ message: String) { logger.error("\(message)") }
    /// Logs a message at at the `fault` level in the unified logging system.
    /// `critical`log messages are an alias to `fault` and write at this level.
    func fault(_ message: String) { logger.fault("\(message)") }
}
