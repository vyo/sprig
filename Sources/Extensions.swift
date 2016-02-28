/*

*/

func toJSONString(string: String) -> String {
    var escapedString = string.stringByReplacingOccurrencesOfString("\\", withString: "\\\\")
    escapedString = escapedString.stringByReplacingOccurrencesOfString("\n", withString: "\\n")
    escapedString = escapedString.stringByReplacingOccurrencesOfString("\r", withString: "\\r")
    escapedString = escapedString.stringByReplacingOccurrencesOfString("\t", withString: "\\t")
    escapedString = escapedString.stringByReplacingOccurrencesOfString("\"", withString: "\\\"")

    return "\"" + escapedString + "\""
}

extension CustomStringConvertible {

    func jsonDescription() -> String
    {
        if self is Int || self is Int32 || self is Int64 || 
            self is UInt || self is UInt32 || self is UInt64 ||
            self is Float || self is Double ||
            self is Bool {
            return self.description
        }
        return toJSONString(self.description)
    }

}

extension String: CustomStringConvertible {
    public var description: String
    {
        return self
    }
}
