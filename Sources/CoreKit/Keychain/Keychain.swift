import Foundation
import KeychainAccess

public struct Keychain {
    public static func save(_ key: String, for wallet: Wallet) throws {
        let keychain = KeychainAccess.Keychain(service: Service.wallets.service(for: .icloud))
            .synchronizable(true)
        try keychain
            .set(key, key: wallet.id)
    }
    public static func save(_ wallet: Wallet) throws {
        let keychain = KeychainAccess.Keychain(service: Service.wallets.service(for: wallet.location.synchronizable ? .icloud : .device))
            .synchronizable(wallet.location.synchronizable)
        try keychain
            .label(wallet.title)
            .comment("\(wallet.coin)---\(wallet.created.ts)")
            .set(wallet.phrase, key: wallet.id)
    }
    public static func delete(_ wallet: Wallet) throws {
        try KeychainAccess.Keychain(service: Service.wallets.service(for: .device)).remove(wallet.id)
        try KeychainAccess.Keychain(service: Service.wallets.service(for: .icloud)).remove(wallet.id)
        try KeychainAccess.Keychain(service: Service.keys.service(for: .device)).remove(wallet.id)
        try KeychainAccess.Keychain(service: Service.keys.service(for: .icloud)).remove(wallet.id)
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
                      created: Core.Date(with: Date(timeIntervalSince1970: date)),
                      location: .keychain(icloud ? .icloud : .device))
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
