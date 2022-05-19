import DevToolsCore
import AppKit

public struct SnippetsModule: ModuleProtocol {
    public let name: String = "Snippets"
    
    public let icon: NSImage = NSImage(systemSymbolName: "chevron.left.forwardslash.chevron.right", accessibilityDescription: "Snippets")!
    
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
