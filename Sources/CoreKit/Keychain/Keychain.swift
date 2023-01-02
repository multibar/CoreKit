import Foundation
import KeychainAccess

public struct Keychain {    
    public static func save(_ wallet: Wallet) throws {
        let keychain = KeychainAccess.Keychain(service: Service.wallets.value)
            .synchronizable(true)
        try keychain
            .label(wallet.title)
            .comment("\(wallet.coin)---\(wallet.created.ts)")
            .set(wallet.phrase, key: wallet.id)
    }
    public static func delete(_ wallet: Wallet) throws {
        let keychain = KeychainAccess.Keychain(service: Service.wallets.value)
            .synchronizable(true)
        try keychain.remove(wallet.id)
    }
    public static func wallet(by id: String) -> Wallet? {
        let keychain = KeychainAccess.Keychain(service: Service.wallets.value)
            .synchronizable(true)
        guard let phrase = keychain[id],
              let attributes = keychain[attributes: id],
              let comments = attributes.comment,
              let coin = comments.components(separatedBy: "---").first,
              let date = Double(comments.components(separatedBy: "---").last ?? "")
        else { return nil }
        return Wallet(id: id,
                      title: attributes.label ?? id,
                      coin: coin,
                      phrase: phrase,
                      created: Core.Date(with: Date(timeIntervalSince1970: date)),
                      location: .keychain)
    }
    public static func wallets() -> [Wallet] {
        let keychain = KeychainAccess.Keychain(service: Service.wallets.value)
            .synchronizable(true)
        return keychain.allKeys().compactMap({wallet(by: $0)})
    }
}

extension Keychain {
    fileprivate enum Service {
        case wallets
        case passcode
        
        public var value: String {
            switch self {
            case .wallets: return "bar.multi.wallet.wallets"
            case .passcode: return "bar.multi.wallet.passcode"
            }
        }
    }
    
}
