import Foundation
import LocalAuthentication

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
extension System.Device {
    public static let biometry: Biometry = {
        let context = LAContext()
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) else { return .none }
        switch context.biometryType {
        case .none:
            return .none
        case .faceID:
            return .faceID
        case .touchID:
            return .touchID
        @unknown default:
            return .unknown
        }
    }()
    
    public enum Biometry {
        case none
        case faceID
        case touchID
        case unknown
    }
}
