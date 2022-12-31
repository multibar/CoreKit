import Foundation
import OrderedCollections

extension Core {
    public struct Date: Codable, Hashable {
        public let date: Foundation.Date
        
        public init(with date: Foundation.Date = Foundation.Date()) {
            self.date = date
        }

        public var log: String {
            return date(with: "HH:mm:ss")
        }
        public var debug: String {
            return date(with: "dd.MM.yyyy HH:mm:ss.SSS")
        }
        public var daily: String {
            return date(with: "dd.MM.yyyy")
        }
        public var components: Components {
            let calendar = Calendar.current
            return Components(day: calendar.component(.day, from: date),
                              month: calendar.component(.month, from: date),
                              year: calendar.component(.year, from: date))
        }
        
        public func date(with format: String, locale: Locale = .en) -> String {
            let formatter = DateFormatter()
            formatter.locale = locale
            formatter.dateFormat = format
            return formatter.string(from: date)
        }
        public func offseted(day: Int) -> Core.Date {
            guard let offseted = Calendar.current.date(byAdding: .day, value: day, to: date) else {
                CoreKit.log(event: "Failed to offset date (\(debug)) by day: \(day)")
                return .now
            }
            return Core.Date(with: offseted)
        }
        public func offseted(month: Int) -> Core.Date {
            guard let offseted = Calendar.current.date(byAdding: .month, value: month, to: date) else {
                CoreKit.log(event: "Failed to offset date (\(debug)) by month: \(month)")
                return .now
            }
            return Core.Date(with: offseted)
        }
        public func offseted(year: Int) -> Core.Date {
            guard let offseted = Calendar.current.date(byAdding: .year, value: year, to: date) else {
                CoreKit.log(event: "Failed to offset date (\(debug)) by year: \(year)")
                return .now
            }
            return Core.Date(with: offseted)
        }
        public static func create(d: Int,
                                  m: Int,
                                  y: Int) -> Core.Date {
            var components = DateComponents()
            components.day = d
            components.month = m
            components.year = y
            return Core.Date(with: Calendar.current.date(from: components) ?? Foundation.Date())
        }
    }
}
extension Core.Date {
    public var ts: Swift.Double {
        return date.timeIntervalSince1970
    }
    public var today: Bool {
        return components.day == Core.Date.now.components.day
    }
    public var expired: Bool {
        return timeleft == 0
    }
    public var timeleft: Int {
        let math = Int(ts - Foundation.Date().timeIntervalSince1970)
        return math >= 0 ? math : 0
    }
    public static var now: Core.Date {
        return Core.Date(with: Foundation.Date())
    }
    public static func minutes(_ value: Int) -> Core.Date {
        return Core.Date(with: Calendar.current.date(byAdding: .minute, value: value, to: Foundation.Date()) ?? Foundation.Date())
    }
    public static func hours(_ value: Int) -> Core.Date {
        return Core.Date(with: Calendar.current.date(byAdding: .hour, value: value, to: Foundation.Date()) ?? Foundation.Date())
    }
    public static func days(_ value: Int) -> Core.Date {
        return Core.Date(with: Calendar.current.date(byAdding: .day, value: value, to: Foundation.Date()) ?? Foundation.Date())
    }
    public static func months(_ value: Int) -> Core.Date {
        return Core.Date(with: Calendar.current.date(byAdding: .month, value: value, to: Foundation.Date()) ?? Foundation.Date())
    }
    public static func years(_ value: Int) -> Core.Date {
        return Core.Date(with: Calendar.current.date(byAdding: .year, value: value, to: Foundation.Date()) ?? Foundation.Date())
    }
}
extension Core.Date {
    public struct Components: Hashable {
        public let day: Int
        public let month: Int
        public let year: Int
    }
}
extension Locale {
    public static var en: Locale {
        return Locale(identifier: "en_GB")
    }
    public static var en_us: Locale {
        return Locale(identifier: "en_US")
    }
}
