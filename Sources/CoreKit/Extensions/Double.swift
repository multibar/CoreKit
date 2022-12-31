import Foundation

extension Double {
    public var string: String {
        return "\(self)"
    }
    public var time: String {
        guard !isNaN else { return "" }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        guard let formatted = formatter.string(from: TimeInterval(self)) else { return "\(self)" }
        if let seconds = Int(formatted), seconds < 10 {
            return "0:0\(formatted)"
        } else if let seconds = Int(formatted), seconds < 60 {
            return "0:\(formatted)"
        } else {
            return formatted
        }
    }
    public func round(to precision: Int) -> String {
        return String(format: "%.\(precision)f", self).replacingOccurrences(of: "-", with: "")
    }
}
