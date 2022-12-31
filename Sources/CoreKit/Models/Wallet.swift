import Foundation

public struct Wallet: Codable, Hashable {
    /// Wallet id.
    public let id: UUID
    
    /// Wallet public title.
    public let title: String
    
    /// Wallet secret phrase.
    public let secret: [String]
    
    /// Wallet location.
    public let location: Location
}

extension Wallet {
    public enum Location: Codable, Hashable {
        case cloud
        case keychain
    }
}
