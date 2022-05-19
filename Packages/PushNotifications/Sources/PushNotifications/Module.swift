import AppKit
import DevToolsCore

public struct PushNotificationsModule: ModuleProtocol {
    public let name: String = "Push Notifications"
    public let icon: NSImage = NSImage(systemSymbolName: "bell.badge", accessibilityDescription: "Bell")!
    public let viewController: NSViewController = ViewController()
    
    public init() {}
}
