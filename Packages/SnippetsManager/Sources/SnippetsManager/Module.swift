import DevToolsCore
import AppKit

public struct SnippetsManagerModule: ModuleProtocol {
    public let name: String = "SnippetsManager"
    
    public let icon: NSImage = NSImage(systemSymbolName: "chevron.left.forwardslash.chevron.right", accessibilityDescription: "SnippetsManager")!
    
    public let viewController: NSViewController = ViewController()
    
    public init() {}
}
