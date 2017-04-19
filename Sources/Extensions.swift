/*

*/

func toJSONString(string: String) -> String {
    var escapedString = string.replacingOccurrences(of: "\\", with: "\\\\")
    escapedString = escapedString.replacingOccurrences(of: "\n", with: "\\n")
    escapedString = escapedString.replacingOccurrences(of: "\r", with: "\\r")
    escapedString = escapedString.replacingOccurrences(of: "\t", with: "\\t")
    escapedString = escapedString.replacingOccurrences(of: "\"", with: "\\\"")

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
        return toJSONString(string: self.description)
    }

}

// extension String: CustomStringConvertible {
//     public var description: String
//     {
//         return self
//     }
// }
