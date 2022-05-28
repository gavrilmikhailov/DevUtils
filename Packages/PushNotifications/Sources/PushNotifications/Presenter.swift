//
//  Presenter.swift
//  
//
//  Created by Гавриил Михайлов on 28.05.2022.
//

import Foundation

final class Presenter {
    
    weak var viewController: ViewControllerDisplayLogic?
    
    func presentListOfDevices(output: String) {
        let viewModels = output
            .split(separator: "\n")
            .map {
                DeviceViewModel(id: UUID().uuidString, name: String($0))
            }
        viewController?.displayListOfDevices(viewModels: viewModels)
    }
}
