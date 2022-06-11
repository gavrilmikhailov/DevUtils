//
//  Module.swift
//  
//
//  Created by Гавриил Михайлов on 10.06.2022.
//

import AppKit
import DevToolsCore

public struct MarkdownEditorModule: ModuleProtocol {
    public let name: String = "Markdown Preview"
    public let icon: NSImage = NSImage(systemSymbolName: "m.square", accessibilityDescription: "Markdown")!
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
