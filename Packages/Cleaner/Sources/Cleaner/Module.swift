//
//  Module.swift
//  
//
//  Created by Гавриил Михайлов on 05.06.2022.
//

import DevToolsCore
import AppKit

public final class CleanerModule: ModuleProtocol {
    public let name: String = "Cleaner"
    public let icon: NSImage = NSImage(systemSymbolName: "trash", accessibilityDescription: "Cleaner")!
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
