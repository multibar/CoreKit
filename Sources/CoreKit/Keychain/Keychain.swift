import Foundation
import KeychainAccess

public struct Keychain {
    public static func save(_ key: String, for wallet: Wallet) throws {
        try keychain(for: .keys, for: wallet.location)
            .set(key, key: wallet.id)
    }
    public static func key(for wallet: Wallet) -> String? {
        return keychain(for: .keys, for: wallet.location)[wallet.id]
    }
}
extension Keychain {
    public static func save(_ wallet: Wallet) throws {
        try keychain(for: .wallets, for: wallet.location)
            .label(wallet.title)
            .comment("\(wallet.coin)---\(wallet.created.seconds)")
            .set(wallet.phrase, key: wallet.id)
    }
    public static func delete(_ wallet: Wallet) throws {
        try KeychainAccess.Keychain(service: Service.keys.service(for: .device)).remove(wallet.id)
        try KeychainAccess.Keychain(service: Service.keys.service(for: .icloud)).remove(wallet.id)
        try KeychainAccess.Keychain(service: Service.wallets.service(for: .device)).remove(wallet.id)
        try KeychainAccess.Keychain(service: Service.wallets.service(for: .icloud)).remove(wallet.id)
    }
    public static func wallets() -> [Wallet] {
        let device = KeychainAccess.Keychain(service: Service.wallets.service(for: .device))
        let icloud = KeychainAccess.Keychain(service: Service.wallets.service(for: .icloud))
        let locals = device.allKeys().compactMap({wallet(by: $0, location: .device)})
        let remote = icloud.allKeys().compactMap({wallet(by: $0, location: .icloud)})
        return locals + remote
    }
    public static func wallet(by id: String, location: Keychain.Location) -> Wallet? {
        let keychain = KeychainAccess.Keychain(service: Service.wallets.service(for: location))
        guard let phrase = keychain[id],
              let attributes = keychain[attributes: id],
              let comments = attributes.comment,
              let coin = comments.components(separatedBy: "---").first,
              let date = Double(comments.components(separatedBy: "---").last ?? ""),
              let icloud = attributes.synchronizable
        else { return nil }
        return Wallet(id: id,
                      title: attributes.label ?? id,
                      coin: coin,
                      phrase: phrase,
                      created: Time(with: date),
                      location: .keychain(icloud ? .icloud : .device))
    }
}
extension Keychain {
    public static var passcode: String? {
        return try? keychain(for: .passcode, for: .keychain(.device))
            .get(Keychain.Passcode.key)
    }
    public static var banned: (until: Time, stage: Int)? {
        guard let _time = try? keychain(for: .passcode, for: .keychain(.device))
            .get(Keychain.Passcode.Ban.time),
              let _stage = try? keychain(for: .passcode, for: .keychain(.device))
            .get(Keychain.Passcode.Ban.stage),
              let time = Double(_time),
              let stage = Int(_stage)
        else { return nil }
        return (until: Time(with: time), stage: stage)
    }
    public static func set(_ passcode: String) throws {
        try keychain(for: .passcode, for: .keychain(.device))
            .set(passcode, key: Keychain.Passcode.key)
    }
    
    @discardableResult
    public static func set(ban stage: Int) -> Time {
        let until = stage.ban
        try? keychain(for: .passcode, for: .keychain(.device))
            .set("\(until.seconds)", key: Keychain.Passcode.Ban.time)
        try? keychain(for: .passcode, for: .keychain(.device))
            .set("\(stage)", key: Keychain.Passcode.Ban.stage)
        return until
    }
}
extension Keychain {
    fileprivate static func keychain(for service: Service, for location: Wallet.Location) -> KeychainAccess.Keychain {
        switch service {
        case .keys:
            return KeychainAccess.Keychain(service: Service.keys.service(for: location.icloud || location.cloud ? .icloud : .device))
                .accessibility(location.icloud || location.cloud ? .whenUnlocked : .whenUnlockedThisDeviceOnly)
                .synchronizable(location.icloud || location.cloud)
        case .wallets:
            return KeychainAccess.Keychain(service: Service.wallets.service(for: location.icloud ? .icloud : .device))
                .accessibility(location.icloud ? .whenUnlocked : .whenUnlockedThisDeviceOnly)
                .synchronizable(location.icloud)
        case .passcode:
            return KeychainAccess.Keychain(service: Service.passcode.service(for: .device))
                .accessibility(.whenUnlockedThisDeviceOnly)
                .synchronizable(false)
        }
    }
}
extension Keychain {
    fileprivate enum Service {
        case keys
        case wallets
        case passcode
        
        fileprivate var device: String {
            switch self {
            case .keys: return "bar.multi.wallet.device.keys"
            case .wallets: return "bar.multi.wallet.device.wallets"
            case .passcode: return "bar.multi.wallet.device.passcode"
            }
        }
        fileprivate var icloud: String {
            switch self {
            case .keys: return "bar.multi.wallet.icloud.keys"
            case .wallets: return "bar.multi.wallet.icloud.wallets"
            case .passcode: return "bar.multi.wallet.icloud.passcode"
            }
        }
        fileprivate func service(for location: Keychain.Location) -> String {
            switch location {
            case .device: return device
            case .icloud: return icloud
            }
        }
    }
    public enum Location: Codable, Hashable {
        case device
        case icloud
    }
}
extension Keychain {
    fileprivate struct Passcode {
        fileprivate static let key = "bar.multi.wallet.device.passcode.value"
        fileprivate struct Ban {
            fileprivate static let time = "bar.multi.wallet.device.passcode.ban.time"
            fileprivate static let stage = "bar.multi.wallet.device.passcode.ban.stage"
        }
    }
}
extension Int {
    fileprivate var ban: Time {
        switch self {
        case 0 : return .now
        case 1 : return .minutes(5)
        case 2 : return .minutes(15)
        case 3 : return .minutes(30)
        case 4 : return .hours(1)
        case 5 : return .hours(2)
        default: return .hours(24)
        }
    }
}
