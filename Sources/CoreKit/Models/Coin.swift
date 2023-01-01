import Foundation

public struct Coin: Codable, Hashable {
    /// Identifiers
    public let id: Id
    
    /// Symbol code, e.g. TON, BTC, ETH, etc.
    public let code: String
    
    /// Coin info.
    public let info: Info
    
    /// Perks available in the Wallet app.
    public let perks: [Perk]
    
    /// Image assets.
    public let icons: Icons?
    
    /// Links to project source website and CoinMarketCap.
    public let links: Links
    
    /// Coin quotes.
    public let quotes: [Quote]
}
extension Coin {
    public struct Id: Codable, Hashable {
        /// Internal Identifier
        public let app: Int
        /// CoinMarketCap Identifier
        public let cmc: Int
        
        public init(app: Int, cmc: Int) {
            self.app = app
            self.cmc = cmc
        }
    }
    public struct Info: Codable, Hashable {
        /// Coin title
        public let title: String
        /// Coin order
        public let order: Int
    }
    public enum Perk: String, Codable {
        /// Store recovery phrase perk
        case key
        /// Wallet support perk
        case wallet
    }
    public struct Icons: Codable, Hashable {
        public let large: Icon?
        public let medium: Icon?
        public let small: Icon?
        
        private enum CodingKeys: String, CodingKey {
            case large
            case medium
            case small
        }
        public init(large: String? = nil,
                    medium: String? = nil,
                    small: String? = nil) {
            if let large { self.large = Icon(source: large) } else { self.large = nil }
            if let medium { self.medium = Icon(source: medium) } else { self.medium = nil }
            if let small { self.small = Icon(source: small) } else { self.small = nil }
        }
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let large = try? container.decode(String?.self, forKey: .large)
            let medium = try? container.decode(String?.self, forKey: .medium)
            let small = try? container.decode(String?.self, forKey: .small)
            if let large { self.large = Icon(source: large) } else { self.large = nil }
            if let medium { self.medium = Icon(source: medium) } else { self.medium = nil }
            if let small { self.small = Icon(source: small) } else { self.small = nil }
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(large?.source, forKey: .large)
            try container.encode(medium?.source, forKey: .medium)
            try container.encode(small?.source, forKey: .small)
        }
        public struct Icon: Codable, Hashable {
            public let source: String
            public let url: URL?
            
            public init(source: String) {
                self.source = source
                self.url = source.url
            }
        }
    }
    public struct Links: Codable, Hashable {
        /// Project URL
        public let origin: Link
        /// CoinMarketCap URL
        public let market: Link
        
        private enum CodingKeys: String, CodingKey {
            case origin
            case market
        }
        public init(origin: String, market: String) {
            self.origin = Link(to: origin)
            self.market = Link(to: market)
        }
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let source = try container.decode(String.self, forKey: .origin)
            let market = try container.decode(String.self, forKey: .market)
            self.origin = Link(to: source)
            self.market = Link(to: market)
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(origin.source, forKey: .origin)
            try container.encode(market.source, forKey: .market)
        }
        
        public struct Link: Codable, Hashable {
            public let source: String
            public let url: URL?
            
            public init(to source: String) {
                self.source = source
                self.url = source.url
            }
        }
    }
    public struct Quote: Codable, Hashable {
        public let fiat: Fiat
        public let price: String
        public let change: Change
        
        public struct Change: Codable, Hashable {
            public let value: String
            public let scale: String
            public let growth: Growth
            
            public enum Growth: String, Codable {
                case positive
                case negative
                case none
            }
        }
    }
}
extension Coin {
    public var words: Int {
        switch code {
        case "TON":
            return 24
        default:
            return 24
        }
    }
}
