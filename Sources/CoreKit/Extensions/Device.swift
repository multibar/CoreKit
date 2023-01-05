import Foundation

extension System {
    public struct Device {}
}
extension System.Device {
    public static var platform: Platform {
        #if os(iOS)
        return .iOS
        #elseif os(tvOS)
        return .tvOS
        #elseif os(macOS)
        return .macOS
        #else
        return .unknown
        #endif
    }
    public enum Platform {
        case iOS
        case tvOS
        case macOS
        case unknown
    }
}
