import Foundation

public struct Settings {
    private init() {}
}
extension Settings {
    public static func set<T>(value: T, for key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    public static func get<T>(value: T.Type, for key: String) -> T? {
        return UserDefaults.standard.value(forKey: key) as? T
    }
    public static func remove(at key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
extension Settings {
    public struct Core {
        private init() {}
    }
}
