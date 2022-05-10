import AppKit
import DevToolsCore

public struct ThemesModule: ModuleProtocol {
    public let name: String = "Themes"
    public let icon: NSImage = NSImage(systemSymbolName: "paintbrush", accessibilityDescription: "Themes")!
    public let viewController: NSViewController = buildViewController()

    public init() {}
}

fileprivate func buildViewController() -> NSViewController {
    let presenter = Presenter()
    let interactor = Interactor(presenter: presenter)
    let viewController = ViewController(interactor: interactor)
    presenter.presenterDelegate = viewController
    return viewController
}
