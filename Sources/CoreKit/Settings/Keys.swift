import Foundation

extension Settings {
    public struct Keys {
        private init() {}
    }
}
extension Settings.Keys {
    public struct Core {
        private init() {}
    }
}
extension Settings.Keys.Core {
    public static let session = "settings/keys/core/session"
}
