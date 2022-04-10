import DevToolsCore
import AppKit

public final class SnippetsManagerBuilder: ModuleBuilderProtocol {

    public init() {}

    public func build() -> ModuleModel {
        let title = "SnippetsManager"
        let icon = NSImage(systemSymbolName: "chevron.left.forwardslash.chevron.right", accessibilityDescription: title)!
        let viewController = ViewController()
        let module = ModuleModel(title: title, icon: icon, viewController: viewController)
        return module
    }
}
