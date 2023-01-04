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
    public let created: Time
    
    /// Wallet location.
    public let location: Location
    
    public init(id: String = UUID().uuidString,
                title: String = "",
                coin: String,
                phrase: String,
                created: Time = time,
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
        case keychain(Keychain.Location)
        
        public var cloud: Bool {
            switch self {
            case .cloud:
                return true
            case .keychain:
                return false
            }
        }
        public var icloud: Bool {
            switch self {
            case .cloud:
                return false
            case .keychain(let location):
                switch location {
                case .icloud:
                    return true
                case .device:
                    return false
                }
            }
        }
        public var device: Bool {
            switch self {
            case .cloud:
                return false
            case .keychain(let location):
                switch location {
                case .icloud:
                    return false
                case .device:
                    return true
                }
            }
        }
    }
}
