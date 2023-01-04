#if os(iOS) || os(tvOS)
import UIKit
#else
import Foundation
#endif

fileprivate let logqueue = DispatchQueue(label: "com.core.log.queue", qos: .background, attributes: .concurrent)

public final class Core {
    public let session: UUID
    public static let shared = Core()
    
    public weak var app: AppBridge?
    public weak var network: NetworkBridge?
    public weak var interface: InterfaceBridge?
    
    public var bridges: [Bridge] {
        return [app, network, interface].compactMap{$0}
    }
    
    public private(set) var events: [Event] = []
    
    public func initialize(with app: AppBridge) {
        self.app = app
    }
    private init() {
        let session = UUID()
        self.session = session
        Core.log(event: "Session \(session.uuidString) — \(Time.now.debug)")
        Core.log(event: "CoreKit initialized")
        setupNotifications()
    }
    
    private func setupNotifications() {
        #if os(iOS) || os(tvOS)
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(didFinishLaunching),  name: UIApplication.didFinishLaunchingNotification, object: nil)
        center.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        center.addObserver(self, selector: #selector(didBecomeActive),     name: UIApplication.didBecomeActiveNotification, object: nil)
        center.addObserver(self, selector: #selector(willResignActive),    name: UIApplication.willResignActiveNotification, object: nil)
        center.addObserver(self, selector: #selector(didEnterBackground),  name: UIApplication.didEnterBackgroundNotification, object: nil)
        center.addObserver(self, selector: #selector(willTerminate),       name: UIApplication.willTerminateNotification, object: nil)
        #endif
    }
    
    public static func log(event: String, source: Event.Source = .app, silent: Bool = false) {
        logqueue.async(flags: .barrier) {
            shared.events.append(Event(event: event, source: source))
        }
        #if DEBUG
        if !silent { print(event) }
        #endif
    }
    
    #if os(iOS) || os(tvOS)
    @objc
    private func didFinishLaunching() {
        Core.log(event: "App Did Finish Launching")
        bridges.forEach { $0.app(state: .didFinishLaunching) }
    }
    
    @objc
    private func willEnterForeground() {
        Core.log(event: "App Will Enter Foreground")
        bridges.forEach { $0.app(state: .willEnterForeground) }
    }
    
    @objc
    private func didBecomeActive() {
        Core.log(event: "App Did Become Active")
        bridges.forEach { $0.app(state: .didBecomeActive) }
    }
    
    @objc
    private func willResignActive() {
        Core.log(event: "App Will Resign Active")
        bridges.forEach { $0.app(state: .willResignActive) }
    }
    
    @objc
    private func didEnterBackground() {
        Core.log(event: "App Did Enter Background")
        bridges.forEach { $0.app(state: .didEnterBackground) }
    }
    
    @objc
    private func willTerminate() {
        Core.log(event: "App Will Terminate")
        bridges.forEach { $0.app(state: .willTerminate) }
    }
    #endif
}

extension Core {
    public func log() async -> URL? {
        let events = events
        var log = ""
        for event in events {
            log += "\(event.source.description) — \(event.recorded.debug): ".uppercased() + "\(event.event)"
            log += "\n"
        }
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let file = docs.appendingPathComponent("\(session.uuidString).txt")
        do {
            try log.write(to: file, atomically: true, encoding: String.Encoding.utf8)
            return file
        } catch {
            return nil
        }
    }
}
public func log(event: String, source: Core.Event.Source = .app, silent: Bool = false) {
    Core.log(event: event, source: source, silent: silent)
}
