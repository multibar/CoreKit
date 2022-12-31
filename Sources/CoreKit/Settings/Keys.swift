import Foundation

extension Settings {
    public struct Keys {}
}

extension Settings.Keys {
    public struct Core {}
}
extension Settings.Keys {
    public struct System {}
}
extension Settings.Keys.System {
    public struct Console {
        public static let app      = "settings/keys/system/console/app"
        public static let user     = "settings/keys/system/console/user"
        public static let images   = "settings/keys/system/console/images"
        public static let player   = "settings/keys/system/console/player"
        public static let storage  = "settings/keys/system/console/storage"
        public static let metrics  = "settings/keys/system/console/metrics"
        public static let network  = "settings/keys/system/console/network"
        public static let firebase = "settings/keys/system/console/firebase"
    }
}
