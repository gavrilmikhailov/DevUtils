import AppKit
import DevToolsCore

public struct PushNotificationsModule: ModuleProtocol {
    public let name: String = "Push Notifications"
    public let icon: NSImage = NSImage(systemSymbolName: "bell.badge", accessibilityDescription: "Bell")!
    public let viewController: NSViewController = buildViewController()
    
    public init() {}
}

fileprivate func buildViewController() -> NSViewController {
    let presenter = Presenter()
    let interactor = Interactor(presenter: presenter)
    let viewController = ViewController(interactor: interactor)
    presenter.viewController = viewController
    return viewController
}

