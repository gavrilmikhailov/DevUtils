import AppKit

public protocol ModuleProtocol {
    
}

public protocol ModuleBuilderProtocol {

    func build() -> ModuleModel
}

public struct ModuleModel {
    public let title: String
    public let icon: NSImage
    public let viewController: NSViewController
    
    public init(title: String, icon: NSImage, viewController: NSViewController) {
        self.title = title
        self.icon = icon
        self.viewController = viewController
    }
}


public final class Debouncer {

    private let delay: TimeInterval
    private var workItem: DispatchWorkItem?
    private weak var queue: DispatchQueue?

    public init(queue: DispatchQueue, delay: TimeInterval = 0.5) {
        self.queue = queue
        self.delay = delay
    }

    public func run(action: @escaping () -> Void) {
        workItem?.cancel()
        workItem = DispatchWorkItem(block: action)
        if let workItem = workItem {
            queue?.asyncAfter(deadline: .now() + delay, execute: workItem)
        }
    }

    public func cancel() {
        workItem?.cancel()
    }
}
