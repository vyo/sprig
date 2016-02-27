import Foundation

/*

*/

struct SprigLogger {

    private static let SPRIG_LEVEL: String = "SPRIG_LEVEL"
    private static var isoFormatter: NSDateFormatter
    {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC")!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.locale = NSLocale.currentLocale()

        return formatter
    }
    private static var global: SprigLogger
    {
        var logger: SprigLogger = SprigLogger(name: "sprig", appender: SprigConsoleAppender(), level: SprigLevel.INFO)
        if let level = NSProcessInfo.processInfo().environment[SPRIG_LEVEL] {
            if level == "10" || "TRACE".caseInsensitiveCompare(level) == NSComparisonResult.OrderedSame {
                logger.level = SprigLevel.TRACE
            } else if level == "20" || "DEBUG".caseInsensitiveCompare(level) == NSComparisonResult.OrderedSame {
                logger.level = SprigLevel.TRACE
            } else if level == "30" || "INFO".caseInsensitiveCompare(level) == NSComparisonResult.OrderedSame {
                logger.level = SprigLevel.TRACE
            } else if level == "40" || "WARN".caseInsensitiveCompare(level) == NSComparisonResult.OrderedSame {
                logger.level = SprigLevel.TRACE
            } else if level == "50" || "ERROR".caseInsensitiveCompare(level) == NSComparisonResult.OrderedSame {
                logger.level = SprigLevel.TRACE
            } else if level == "60" || "FATAL".caseInsensitiveCompare(level) == NSComparisonResult.OrderedSame {
                logger.level = SprigLevel.TRACE
            }
        }

        return logger
    }

    var level: SprigLevel = SprigLevel.INFO
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
