import DevToolsCore
import AppKit

public struct SnippetsModule: ModuleProtocol {
    public let name: String = "Snippets"
    
    public let icon: NSImage = NSImage(systemSymbolName: "chevron.left.forwardslash.chevron.right", accessibilityDescription: "Snippets")!
    
    public let viewController: NSViewController = ViewController()
    
    public init() {}
}
