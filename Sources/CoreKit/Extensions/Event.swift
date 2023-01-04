import Foundation

extension Core {
    public struct Event {
        public let event: String
        public let source: Source
        public let recorded: Time
        
        public init(event: String, source: Source, date: Foundation.Date = Foundation.Date()) {
            self.event = event
            self.source = source
            self.recorded = Time(with: date)
        }
        
        public enum Source {
            case app
            case user
            case images
            case player
            case storage
            case metrics
            case network
            case firebase
            
            public var description: String {
                switch self {
                case .app     : return "System"
                case .user    : return "User"
                case .images  : return "Images"
                case .player  : return "Player"
                case .storage : return "Storage"
                case .metrics : return "Metrics"
                case .network : return "Network"
                case .firebase: return "Firebase"
                }
            }
            
            public var available: Bool {
                switch self {
                case .app     : return Settings.System.Console.app
                case .user    : return Settings.System.Console.user
                case .images  : return Settings.System.Console.images
                case .player  : return Settings.System.Console.player
                case .storage : return Settings.System.Console.storage
                case .metrics : return Settings.System.Console.metrics
                case .network : return Settings.System.Console.network
                case .firebase: return Settings.System.Console.network
                }
            }
        }
    }
}
