import Foundation

public struct Wallet: Codable, Hashable {
    /// Wallet id.
    public let id: String
    
    /// Wallet associated coin code
    public let coin: String
    
    /// Wallet public title.
    public let title: String
    
    /// Wallet secret encrypted phrase.
    public let phrase: String
    
    /// Wallet creation date.
    public let created: Core.Date
    
    /// Wallet location.
    public let location: Location
    
    public init(id: String = UUID().uuidString,
                title: String = "",
                coin: String,
                phrase: String,
                created: Core.Date = .now,
                location: Location) {
        self.id = id
        self.coin = coin
        self.title = title.empty ? id.components(separatedBy: "-").first ?? id : title
        self.phrase = phrase
        self.created = created
        self.location = location
    }
}

extension Wallet {
    public enum Location: Codable, Hashable {
        case cloud
        case keychain
    }
}
