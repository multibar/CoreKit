import Foundation

extension String {
    public var empty: Bool {
        return isEmpty
    }
    public var random: String {
        guard let element = randomElement() else { return "" }
        return String(element)
    }
    public var attributed: NSAttributedString {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data,
                                          options: [
                                            .documentType: NSAttributedString.DocumentType.html,
                                            .characterEncoding: String.Encoding.utf8.rawValue
                                          ],
                                          documentAttributes: nil)
        } catch {
            return NSAttributedString(string: self)
        }
    }
    public static func random(from characters: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%&()0123456789") -> String {
        return characters.random
    }
}
