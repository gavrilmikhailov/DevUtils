//
//  Builder.swift
//
//
//  Created by Гавриил Михайлов on 26.03.2022.
//

import AppKit
import DevToolsCore

public struct JsonPrettifierModule: ModuleProtocol {
    public let name: String = "JSON Prettifier"
    
    public let icon: NSImage = NSImage(systemSymbolName: "curlybraces", accessibilityDescription: "JSON Prettifier")!
    
    public let viewController: NSViewController

    public init() {
        let presenter = Presenter()
        let interactor = Interactor(presenter: presenter)
        let viewController = ViewController(title: "JSON Prettifier", interactor: interactor)
        presenter.viewController = viewController
        self.viewController = viewController
    }
}
