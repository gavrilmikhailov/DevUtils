//
//  Module.swift
//  
//
//  Created by Гавриил Михайлов on 05.06.2022.
//

import AppKit
import DevToolsCore

public struct UserDataModule: ModuleProtocol {
    public let name: String = "User Data"
    public let icon: NSImage = NSImage(systemSymbolName: "rectangle.badge.person.crop", accessibilityDescription: "User Data")!
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
