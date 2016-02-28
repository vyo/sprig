import Foundation

/*

*/

struct Logger {

    struct Global {

        private var logger: Logger = Logger(name: "sprig", appender: ConsoleAppender(), level: Level.INFO)
        var name: String
        {
            get
            {
                return logger.name
            }
        }
        var appender: Appender
        {
            get
            {
                return logger.appender
            }
            set(appender)
            {
                logger.appender = appender
            }
        }
        var level: Level
        {
            get
            {
                return logger.level
            }
            set(level)
            {
                logger.level = level
            }
        }

        init() {
            if let levelEnv = NSProcessInfo.processInfo().environment[SPRIG_LEVEL] {
                if levelEnv == "10" || "TRACE".caseInsensitiveCompare(levelEnv) == NSComparisonResult.OrderedSame {
                    level = Level.TRACE
                } else if levelEnv == "20" || "DEBUG".caseInsensitiveCompare(levelEnv) == NSComparisonResult.OrderedSame {
                    level = Level.DEBUG
                } else if levelEnv == "30" || "INFO".caseInsensitiveCompare(levelEnv) == NSComparisonResult.OrderedSame {
                    level = Level.INFO
                } else if levelEnv == "40" || "WARN".caseInsensitiveCompare(levelEnv) == NSComparisonResult.OrderedSame {
                    level = Level.WARN
                } else if levelEnv == "50" || "ERROR".caseInsensitiveCompare(levelEnv) == NSComparisonResult.OrderedSame {
                    level = Level.ERROR
                } else if levelEnv == "60" || "FATAL".caseInsensitiveCompare(levelEnv) == NSComparisonResult.OrderedSame {
                    level = Level.FATAL
                }
            }
        }
    }

    private static let SPRIG_LEVEL: String = "SPRIG_LEVEL"
    private static var isoFormatter: NSDateFormatter
    {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC")!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.locale = NSLocale.currentLocale()

        return formatter
    }
    static var global: Global = Global()

    var level: Level
    var appender: Appender
    let name: String

    init(name: String, appender: Appender = Logger.global.appender, level: Level = Logger.global.level) {
        self.name = name
        self.appender = appender
        self.level = level
    }

    func log(level: Level, entry: CustomStringConvertible) {

        let processInfo: NSProcessInfo = NSProcessInfo.processInfo()
        let pid: Int32 = processInfo.processIdentifier
        let hostname: String = processInfo.hostName
        let thread: NSThread = NSThread.currentThread()

        var logString: String = "{"
        logString += Entry(key: "pid", value: pid).description + ","
        logString += Entry(key: "hostname", value: hostname).description + ","
        logString += Entry(key: "thread", value: thread).description + ","
        logString += Entry(key: "time", value: NSDate()).description + ","
        logString += Entry(key: "level", value: level.rawValue).description + ","
        logString += Entry(key: "name", value: name).description + ","
        logString += Entry(key: "msg", value: entry).description
        logString += "}"

        appender.write(logString)
    }

    private static func globalLog(level: Level, entry: CustomStringConvertible) {

    }

    func trace(entry: CustomStringConvertible)
    {
        log(Level.TRACE, entry: entry)
    }

    func debug(entry: CustomStringConvertible)
    {
        log(Level.DEBUG, entry: entry)
    }

    func info(entry: CustomStringConvertible)
    {
        log(Level.INFO, entry: entry)
    }

    func warn(entry: CustomStringConvertible)
    {
        log(Level.WARN, entry: entry)
    }

    func error(entry: CustomStringConvertible)
    {
        log(Level.ERROR, entry: entry)
    }

    func fatal(entry: CustomStringConvertible)
    {
        log(Level.FATAL, entry: entry)
    }

}
