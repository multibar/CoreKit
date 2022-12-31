import Foundation

public protocol Bridge: AnyObject {
    func app(state: System.App.State)
    func user(state: System.User.State)
}

public protocol AppBridge: Bridge {
    func notifications() async -> Notifications.State
    func requestNotifications()
}

public protocol NetworkBridge: Bridge {
    var host: String { get }
    var user: System.User? { get }
    var state: System.User.State { get }
}

public protocol InterfaceBridge: Bridge {
    var device: String { get }
}
