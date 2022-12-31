import Foundation
import KeychainAccess

public struct Keychain {
    public static func set(value: String, for key: String) {
        KeychainAccess.Keychain(service: "service")[key] = value
    }
    public static func get(for key: String) -> String? {
        return KeychainAccess.Keychain(service: "service")[key]
    }
    public static func remove(at key: String) {
        try? KeychainAccess.Keychain(service: "service").remove(key)
    }
}
