#if canImport(UIKit)
import UIKit
#else
import Foundation
#endif

extension System {
    public struct App {}
}
extension System.App {
    public static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
}
extension System.App {
    #if canImport(UIKit)
    public static var state: UIApplication.State {
        return UIApplication.shared.applicationState
    }
    public enum State {
        case didFinishLaunching
        case willEnterForeground
        case didBecomeActive
        case willResignActive
        case didEnterBackground
        case willTerminate
    }
    #else
    public enum State {
        case started
        case running
        case stopped
    }
    #endif
}
extension System.App {
    public static var client: String {
        let client: String = {
            if let info = Bundle.main.infoDictionary {
                let appName = info["App Name"] as? String ?? info["CFBundleName"] as? String ?? "Unknown"
                let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
                let osNameVersion: String = {
                    let version = ProcessInfo.processInfo.operatingSystemVersion
                    var versionString = "\(version.majorVersion).\(version.minorVersion)"
                    if version.patchVersion != 0 { versionString += ".\(version.patchVersion)" }
                    let osName: String = {
                        #if os(iOS)
                        return UIDevice.current.userInterfaceIdiom == .pad ? "iPadOS" : "iOS"
                        #elseif os(watchOS)
                        return "watchOS"
                        #elseif os(tvOS)
                        return "tvOS"
                        #elseif os(macOS)
                        return "macOS"
                        #elseif os(Linux)
                        return "Linux"
                        #else
                        return "Unknown"
                        #endif
                    }()
                    return "\(osName) \(versionString)"
                }()
                #if canImport(UIKit)
                return "\(appName) \(appVersion) (Apple, \(Core.shared.interface?.device ?? UIDevice.current.name), \(osNameVersion))"
                #elseif os(macOS)
                return "\(appName) \(appVersion) (Apple, Mac, \(osNameVersion))"
                #else
                return "\(appName) \(appVersion) (Apple, Unknown Device, \(osNameVersion))"
                #endif
            }
            return "Unknown Apple Device"
        }()
        return client
    }
}
