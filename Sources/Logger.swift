import Foundation

/*

*/

class Logger {

    static private let SPRIG_LEVEL: String = "SPRIG_LEVEL"
    static private let SPRIG_WORKERS: String = "SPRIG_WORKERS"
    static private let SPRIG_QUEUE: String = "SPRIG_QUEUE"
    
    static var level: Level = Level.INFO
    
    private static var isoFormatter: NSDateFormatter 
    {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC")!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.locale = NSLocale.currentLocale()
        return formatter
    }
    private static let logger: Logger = Logger(name: "sprig", appender: ConsoleAppender())
    
    var appender: Appender
    let name: String
    
    init(name: String, appender: Appender) {
        self.name = name
        self.appender = appender
    }

    func log() {

        let processInfo: NSProcessInfo = NSProcessInfo.processInfo()
        let pid: Int32 = processInfo.processIdentifier
        let hostName: String = processInfo.hostName
        let thread: NSThread = NSThread.currentThread()

        appender.write("\(Logger.isoFormatter.stringFromDate(NSDate()))")
        appender.write("\(pid)")
        appender.write("\(hostName)")
        appender.write("\(thread)")
    }

}

