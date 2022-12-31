import Foundation

public struct System {}

extension System {
    public static var environment: Environment {
        #if DEBUG
        return .debug
        #else
        switch Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt" {
        case true : return .test
        case false: return .production
        }
        #endif
    }
    public enum Environment {
        case test
        case debug
        case production
        
        public var description: String {
            switch self {
            case .test: return "Test"
            case .debug: return "Debug"
            case .production: return "Production"
            }
        }
    }
}
