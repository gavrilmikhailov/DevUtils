import AppKit
import DevToolsCore

public struct ThemesModule: ModuleProtocol {
    public let name: String = "Themes"
    public let icon: NSImage = NSImage(systemSymbolName: "paintbrush", accessibilityDescription: "Themes")!
    public let viewController: NSViewController = ViewController()
    
    public init() {}
}
