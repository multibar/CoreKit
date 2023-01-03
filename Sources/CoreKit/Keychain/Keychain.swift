import Foundation
import KeychainAccess

public struct Keychain {
    public static func save(_ key: String, for wallet: Wallet) throws {
        let keychain = KeychainAccess.Keychain(service: Service.wallets.value)
            .synchronizable(true)
        try keychain
            .set(key, key: wallet.id)
    }
    public static func save(_ wallet: Wallet) throws {
        let keychain = KeychainAccess.Keychain(service: Service.wallets.value)
            .synchronizable(wallet.location.synchronizable)
        try keychain
            .label(wallet.title)
            .comment("\(wallet.coin)---\(wallet.created.ts)")
            .set(wallet.phrase, key: wallet.id)
    }
    public static func delete(_ wallet: Wallet) throws {
        try KeychainAccess.Keychain(service: Service.wallets.value).remove(wallet.id)
        try KeychainAccess.Keychain(service: Service.keys.value).remove(wallet.id)
    }
    public static func wallet(by id: String) -> Wallet? {
        let keychain = KeychainAccess.Keychain(service: Service.wallets.value)
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
    public static func wallets() -> [Wallet] {
        let keychain = KeychainAccess.Keychain(service: Service.wallets.value)
        return keychain.allKeys().compactMap({wallet(by: $0)})
    }
}

extension Keychain {
    fileprivate enum Service {
        case keys
        case wallets
        case passcode
        
        public var value: String {
            switch self {
            case .keys: return "bar.multi.wallet.keys"
            case .wallets: return "bar.multi.wallet.wallets"
            case .passcode: return "bar.multi.wallet.passcode"
            }
        }
    }
    public enum Location: Codable, Hashable {
        case device
        case icloud
    }
}
