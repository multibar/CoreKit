import Foundation
import LocalAuthentication

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
    
    public static func authenticate(reason: String = "Authentication") async throws {
        let reason = (reason.empty || reason.replacingOccurrences(of: " ", with: "").empty) ? "Authentication" : reason
        try await LAContext().evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason)
    }
    
    public enum Biometry {
        case none
        case faceID
        case touchID
        case unknown
    }
}
