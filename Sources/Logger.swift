import Foundation

public class Logger {

    struct Global {

        private var logger: Logger = Logger("sprig", appender: ConsoleAppender(), level: Level.INFO)
        var name: String
        var appender: Appender
        var level: Level

        init() {
            self.name = logger.name
            self.appender = logger.appender
            self.level = logger.level

            if let levelEnv = ProcessInfo.processInfo.environment[sprigLevel] {
                if levelEnv == "10" || "TRACE".caseInsensitiveCompare(levelEnv) == ComparisonResult.orderedSame {
                    self.level = Level.TRACE
                } else if levelEnv == "20" || "DEBUG".caseInsensitiveCompare(levelEnv) == ComparisonResult.orderedSame {
                    self.level = Level.DEBUG
                } else if levelEnv == "30" || "INFO".caseInsensitiveCompare(levelEnv) == ComparisonResult.orderedSame {
                    self.level = Level.INFO
                } else if levelEnv == "40" || "WARN".caseInsensitiveCompare(levelEnv) == ComparisonResult.orderedSame {
                    self.level = Level.WARN
                } else if levelEnv == "50" || "ERROR".caseInsensitiveCompare(levelEnv) == ComparisonResult.orderedSame {
                    self.level = Level.ERROR
                } else if levelEnv == "60" || "FATAL".caseInsensitiveCompare(levelEnv) == ComparisonResult.orderedSame {
                    self.level = Level.FATAL
                }
            }
        }
    }

    private static let sprigLevel: String = "SPRIG_LEVEL"
    private static var isoFormatter: DateFormatter {
        let formatter: DateFormatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.locale = Locale.current

        return formatter
    }
    static var global: Global = Global()

    var level: Level
    var appender: Appender
    let name: String

    public init(_ name: String, appender: Appender = Logger.global.appender, level: Level = Logger.global.level) {
        self.name = name
        self.appender = appender
        self.level = level
    }

    func log(level: Level, _ entry: CustomStringConvertible, customEntries: [Entry]) {

        let processInfo: ProcessInfo = ProcessInfo.processInfo
        let pid: Int32 = processInfo.processIdentifier
        let hostname: String = processInfo.hostName
        let thread: Thread = Thread.current

        var logString: String = "{"
        logString += Entry(key: "pid", value: pid).description + ","
        logString += Entry(key: "hostname", value: hostname).description + ","
        logString += Entry(key: "thread", value: thread.name!).description + ","
        logString += Entry(key: "time", value: Date()).description + ","
        logString += Entry(key: "level", value: level.rawValue).description + ","
        logString += Entry(key: "name", value: name).description + ","
        logString += Entry(key: "msg", value: entry).description

        if (customEntries.count > 0) {
            logString += ","
        }
        for i in 0...customEntries.count - 1 {
            logString += Entry(key: customEntries[i].key, value: customEntries[i].value).description + ","
        }
        if (customEntries.count > 0) {
            logString += Entry(key: customEntries[customEntries.count - 1].key, value: customEntries[customEntries.count - 1].value).description
        }

        logString += "}"

        appender.write(any: logString)
    }

    private static func globalLog(level: Level, _ entry: CustomStringConvertible) {

    }

    public func trace(_ entry: CustomStringConvertible, customEntries: Entry...) {
        log(level: Level.TRACE, entry, customEntries: customEntries)
    }

    public func debug(_ entry: CustomStringConvertible, customEntries: Entry...) {
        log(level: Level.DEBUG, entry, customEntries: customEntries)
    }

    public func info(_ entry: CustomStringConvertible, customEntries: Entry...) {
        log(level: Level.INFO, entry, customEntries: customEntries)
    }

    public func warn(_ entry: CustomStringConvertible, customEntries: Entry...) {
        log(level: Level.WARN, entry, customEntries: customEntries)
    }

    public func error(_ entry: CustomStringConvertible, customEntries: Entry...) {
        log(level: Level.ERROR, entry, customEntries: customEntries)
    }

    public func fatal(_ entry: CustomStringConvertible, customEntries: Entry...) {
        log(level: Level.FATAL, entry, customEntries: customEntries)
    }

}
