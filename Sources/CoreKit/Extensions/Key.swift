import Foundation

public enum Key {
    case x64
    case x128
    case x256
    case x512
    case x1024
    
    public var random: String {
        var random = ""
        switch self {
        case .x64  : for _ in 0..<2  { random.append(.x32) }
        case .x128 : for _ in 0..<4  { random.append(.x32) }
        case .x256 : for _ in 0..<8  { random.append(.x32) }
        case .x512 : for _ in 0..<16 { random.append(.x32) }
        case .x1024: for _ in 0..<32 { random.append(.x32) }
        }
        return random.map { Bool.random() ? String($0).lowercased() : String($0).uppercased() }.joined(separator: "")
    }
}
extension String {
    fileprivate static var x32: String {
        return UUID().uuidString.replacingOccurrences(of: "-", with: "")
    }
}
