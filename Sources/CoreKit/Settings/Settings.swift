import Foundation
import KeychainAccess

public struct Settings {
    private static let service = "com.app.keychain"
    
    public static func set<T>(value: T, for key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    public static func get<T>(value: T.Type, for key: String) -> T? {
        return UserDefaults.standard.value(forKey: key) as? T
    }
    
    public static func remove(at key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    public static func sensitive(for key: String) -> String? {
        return Keychain(service: service)[key]
    }
    
    public static func protect(sensitive value: String?, for key: String) {
        Keychain(service: service)[key] = value
    }
    
    public static func release(at key: String) {
        try? Keychain(service: service).remove(key)
    }
    
    private init() {}
}

extension Settings {
    public struct Core   { private init() {} }
    public struct System { private init() {} }
}

extension Settings.System {
    public struct Console {
        public static var app: Bool {
            get {
                let value = Settings.get(value: Bool.self, for: Settings.Keys.System.Console.app) ?? true
                return value
            } set {
                Settings.set(value: newValue, for: Settings.Keys.System.Console.app)
            }
        }
        public static var user: Bool {
            get {
                let value = Settings.get(value: Bool.self, for: Settings.Keys.System.Console.user) ?? false
                return value
            } set {
                Settings.set(value: newValue, for: Settings.Keys.System.Console.user)
            }
        }
        public static var images: Bool {
            get {
                let value = Settings.get(value: Bool.self, for: Settings.Keys.System.Console.images) ?? true
                return value
            } set {
                Settings.set(value: newValue, for: Settings.Keys.System.Console.images)
            }
        }
        public static var player: Bool {
            get {
                let value = Settings.get(value: Bool.self, for: Settings.Keys.System.Console.player) ?? true
                return value
            } set {
                Settings.set(value: newValue, for: Settings.Keys.System.Console.player)
            }
        }
        public static var storage: Bool {
            get {
                let value = Settings.get(value: Bool.self, for: Settings.Keys.System.Console.storage) ?? true
                return value
            } set {
                Settings.set(value: newValue, for: Settings.Keys.System.Console.storage)
            }
        }
        public static var metrics: Bool {
            get {
                let value = Settings.get(value: Bool.self, for: Settings.Keys.System.Console.metrics) ?? true
                return value
            } set {
                Settings.set(value: newValue, for: Settings.Keys.System.Console.metrics)
            }
        }
        public static var network: Bool {
            get {
                let value = Settings.get(value: Bool.self, for: Settings.Keys.System.Console.network) ?? true
                return value
            } set {
                Settings.set(value: newValue, for: Settings.Keys.System.Console.network)
            }
        }
        public static var firebase: Bool {
            get {
                let value = Settings.get(value: Bool.self, for: Settings.Keys.System.Console.firebase) ?? true
                return value
            } set {
                Settings.set(value: newValue, for: Settings.Keys.System.Console.firebase)
            }
        }
    }
}
