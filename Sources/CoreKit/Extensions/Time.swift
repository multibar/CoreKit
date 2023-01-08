import Foundation
import OrderedCollections

public struct Time {
    public let date: Date
    public let seconds: Double
            
    public init(with date: Date = Date()) {
        self.date = date
        self.seconds = date.seconds
    }
    public init(with seconds: Double) {
        self.date = Date(with: seconds)
        self.seconds = seconds
    }
}
extension Time {
    public var debug: String {
        return formatted(to: "dd.MM.yyyy HH:mm:ss.SSS")
    }
    public func formatted(to format: String, locale: Locale = .en) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
extension Time {
    public var expired: Bool {
        return seconds(to: Time.now) == 0.0
    }
    public func seconds(to date: Time) -> Double {
        let seconds = seconds - date.seconds
        return seconds >= 0.0 ? seconds : 0.0
    }
    public static var now: Time { Time() }
}
extension Time {
    public static func seconds(_ value: Int) -> Time {
        return Time(with: Calendar.current.date(byAdding: .second, value: value, to: Date()) ?? Date())
    }
    public static func minutes(_ value: Int) -> Time {
        return Time(with: Calendar.current.date(byAdding: .minute, value: value, to: Date()) ?? Date())
    }
    public static func hours(_ value: Int) -> Time {
        return Time(with: Calendar.current.date(byAdding: .hour, value: value, to: Date()) ?? Date())
    }
    public static func days(_ value: Int) -> Time {
        return Time(with: Calendar.current.date(byAdding: .day, value: value, to: Date()) ?? Date())
    }
    public static func months(_ value: Int) -> Time {
        return Time(with: Calendar.current.date(byAdding: .month, value: value, to: Date()) ?? Date())
    }
    public static func years(_ value: Int) -> Time {
        return Time(with: Calendar.current.date(byAdding: .year, value: value, to: Date()) ?? Date())
    }
}
extension Time: Codable, Hashable {
    private enum CodingKeys: String, CodingKey {
        case date
        case seconds
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let seconds = try container.decode(Double.self, forKey: .seconds)
        self.date = Date(with: seconds)
        self.seconds = seconds
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(seconds, forKey: .seconds)
    }
}
extension Date {
    public var seconds: Double { timeIntervalSince1970 }
    public init(with seconds: Double) {
        self.init(timeIntervalSince1970: seconds)
    }
}
