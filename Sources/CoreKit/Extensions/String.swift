import Foundation

extension String {
    public var empty: Bool {
        return isEmpty
    }
    public var attributed: NSAttributedString {
        return NSAttributedString(string: self)
    }
}
