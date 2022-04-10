//
//  Builder.swift
//
//
//  Created by Гавриил Михайлов on 26.03.2022.
//

import AppKit
import DevToolsCore

public final class JsonPrettifierBuilder: ModuleBuilderProtocol {
    
    public init() {}

    public func build() -> ModuleModel {
        let title = "JSON Prettifier"
        let icon = NSImage(systemSymbolName: "curlybraces", accessibilityDescription: title)!
        
        let presenter = Presenter()
        let interactor = Interactor(presenter: presenter)
        let viewController = ViewController(title: title, interactor: interactor)
        presenter.viewController = viewController
        
        let module = ModuleModel(title: title, icon: icon, viewController: viewController)
        return module
    }
}
