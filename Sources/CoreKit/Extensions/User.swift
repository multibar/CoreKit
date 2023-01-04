import Foundation

extension System {
    public struct User {
        public let id: String
        
        public init(id: String) {
            self.id = id
        }
    }
}
extension System.User {
    public enum State {
        case authorized
        case unauthorized
    }
}
extension System.User {
    public static var current: System.User? {
        return Core.shared.network?.user
    }
}
