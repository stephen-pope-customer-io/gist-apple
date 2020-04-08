import Foundation
import os.log

extension OSLog {
    static let gist = OSLog(subsystem: "sh.bourbon.gist", category: "messaging")
}

class Logger {
    static let instance = Logger()
    var enabled = false

    func info(message: String) {
        if enabled { os_log("%@", log: OSLog.gist, type: .info, message) }
    }

    func debug(message: String) {
        if enabled { os_log("%@", log: OSLog.gist, type: .debug, message) }
    }

    func error(message: String) {
        os_log("%@", log: OSLog.gist, type: .error, message)
    }
}
