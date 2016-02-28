import Foundation

/*

*/

struct SprigLogger {

    struct SprigGlobal {

        private var logger: SprigLogger = SprigLogger(name: "sprig", appender: SprigConsoleAppender(), level: SprigLevel.INFO)
        var name: String
        {
            get
            {
                return logger.name
            }
        }
        var appender: SprigAppender
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
        var level: SprigLevel
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
                    level = SprigLevel.TRACE
                } else if levelEnv == "20" || "DEBUG".caseInsensitiveCompare(levelEnv) == NSComparisonResult.OrderedSame {
                    level = SprigLevel.DEBUG
                } else if levelEnv == "30" || "INFO".caseInsensitiveCompare(levelEnv) == NSComparisonResult.OrderedSame {
                    level = SprigLevel.INFO
                } else if levelEnv == "40" || "WARN".caseInsensitiveCompare(levelEnv) == NSComparisonResult.OrderedSame {
                    level = SprigLevel.WARN
                } else if levelEnv == "50" || "ERROR".caseInsensitiveCompare(levelEnv) == NSComparisonResult.OrderedSame {
                    level = SprigLevel.ERROR
                } else if levelEnv == "60" || "FATAL".caseInsensitiveCompare(levelEnv) == NSComparisonResult.OrderedSame {
                    level = SprigLevel.FATAL
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
    static var global: SprigGlobal = SprigGlobal()

    var level: SprigLevel
    var appender: SprigAppender
    let name: String

    init(name: String, appender: SprigAppender = SprigLogger.global.appender, level: SprigLevel = SprigLogger.global.level) {
        self.name = name
        self.appender = appender
        self.level = level
    }

    func log(level: SprigLevel, entry: SprigLoggable) {

        let processInfo: NSProcessInfo = NSProcessInfo.processInfo()
        let pid: Int32 = processInfo.processIdentifier
        let hostname: String = processInfo.hostName
        let thread: NSThread = NSThread.currentThread()

        var logString: String = "{"
        logString += SprigEntry(key: "pid", value: pid).description + ","
        logString += SprigEntry(key: "hostname", value: hostname).description + ","
        logString += SprigEntry(key: "thread", value: thread).description + ","
        logString += SprigEntry(key: "time", value: NSDate()).description + ","
        logString += SprigEntry(key: "level", value: level.rawValue).description + ","
        logString += SprigEntry(key: "name", value: name).description + ","
        logString += SprigEntry(key: "msg", value: "message").description
        logString += "}"

        appender.write(logString)
    }

    private static func globalLog(level: SprigLevel, entry: SprigLoggable) {

    }

    func trace(entry: SprigLoggable)
    {
        log(SprigLevel.TRACE, entry: entry)
    }

    func debug(entry: SprigLoggable)
    {
        log(SprigLevel.DEBUG, entry: entry)
    }

    func info(entry: SprigLoggable)
    {
        log(SprigLevel.INFO, entry: entry)
    }

    func warn(entry: SprigLoggable)
    {
        log(SprigLevel.WARN, entry: entry)
    }

    func error(entry: SprigLoggable)
    {
        log(SprigLevel.ERROR, entry: entry)
    }

    func fatal(entry: SprigLoggable)
    {
        log(SprigLevel.FATAL, entry: entry)
    }

}
