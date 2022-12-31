import Foundation

public struct Fiat: Codable, Hashable {
    public let id: Id
    public let code: String
    public let info: Info
    public let icons: Icons?
}
extension Fiat {
    public struct Id: Codable, Hashable {
        public let app: Int
        public let cmc: Int
    }
    public struct Info: Codable, Hashable {
        public let sign: String
        public let title: String
        public let order: Int
    }
    public struct Icons: Codable, Hashable {
        public let large: String?
        public let medium: String?
        public let small: String?
    }
}
