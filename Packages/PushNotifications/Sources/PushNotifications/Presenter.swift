//
//  Presenter.swift
//  
//
//  Created by Гавриил Михайлов on 28.05.2022.
//

import Foundation
import DevToolsCore

final class Presenter {
    
    weak var viewController: ViewControllerDisplayLogic?
    
    func presentListOfDevices(devicesModel: DevicesModel) {
        let viewModels = devicesModel.devices
            .filter { $0.key.contains("iOS") }
            .sorted(by: { $0.key < $1.key })
            .compactMap({ $0.value })
            .map { devices in
                devices
                    .filter { $0.isAvailable }
                    .map { DeviceViewModel(id: $0.udid, name: $0.name, isBooted: $0.state == .booted) }
            }
            .joined()
            .map { $0 }
        viewController?.displayListOfDevices(viewModels: viewModels)
    }
    
    func presentSelectDevice(id: String?) {
        viewController?.displaySelectDevice(id: id)
    }
    
    func presentError(title: String, message: String) {
        viewController?.displayError(title: title, message: message)
    }
}
