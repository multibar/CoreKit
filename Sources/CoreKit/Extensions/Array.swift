import Foundation
import OrderedCollections

extension Array {
    public var empty: Bool {
        return isEmpty
    }
    public func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
extension Array where Element == String {
    public func filtered(by word: String) -> [String] {
        return word.empty ? self : self.filter({$0.lowercased().prefix(word.count) == word.lowercased()})
    }
}
extension OrderedSet {
    public var empty: Bool {
        return isEmpty
    }
}
extension OrderedDictionary {
    public var empty: Bool {
        return isEmpty
    }
}
