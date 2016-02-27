

protocol SprigLoggable {

    func jsonDescription() -> String

}

func escape(string: String) -> String {
    var escapedString = string.stringByReplacingOccurrencesOfString("\\", withString: "\\\\")
    escapedString = escapedString.stringByReplacingOccurrencesOfString("\n", withString: "\\n")
    escapedString = escapedString.stringByReplacingOccurrencesOfString("\r", withString: "\\r")
    escapedString = escapedString.stringByReplacingOccurrencesOfString("\t", withString: "\\t")
    escapedString = escapedString.stringByReplacingOccurrencesOfString("\"", withString: "\\\"")

    return escapedString
}

extension CustomStringConvertible {

    func jsonDescription() -> String
    {
        return escape(self.description)
    }

}

extension String: SprigLoggable {

    func jsonDescription() -> String
    {
        return escape(self)
    }

}
