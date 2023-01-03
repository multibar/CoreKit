import Foundation

public struct Key {}
extension Key {
    public static func generate() -> String {
        var key = ""
        let random = UUID()
        let cased = random.uuidString.map { Bool.random() ? String($0).lowercased() : String($0).uppercased() }.joined(separator: "")
        cased.forEach { key.append($0); key.append(String.Element.random) }
        return key.replacingOccurrences(of: "-", with: "")
    }
}
