

struct Entry : CustomStringConvertible {

    let key: String
    let value: CustomStringConvertible
    var description: String
    {
        return key.jsonDescription() + ":" + value.jsonDescription()
    }

    init(key: String, value: CustomStringConvertible) {
        self.key = key
        self.value = value
    }

}
