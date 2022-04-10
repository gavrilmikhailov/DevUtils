import AppKit
import DevToolsCore

public final class ThemesModule: ModuleBuilderProtocol {
    
    public init() {}
    
    public func build() -> ModuleModel {
        ModuleModel(
            title: "Themes",
            icon: NSImage(systemSymbolName: "paintbrush", accessibilityDescription: "Themes")!,
            viewController: ViewController())
    }
}
