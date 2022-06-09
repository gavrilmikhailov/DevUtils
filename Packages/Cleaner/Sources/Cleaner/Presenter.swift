//
//  Presenter.swift
//  
//
//  Created by Гавриил Михайлов on 05.06.2022.
//

import Foundation

final class Presenter {
    
    weak var viewController: ViewControllerDisplayLogic?

    func presentDerivedDataSize(bytesCount: UInt64) {
        let formattedSize = getFormattedSize(of: bytesCount)
        DispatchQueue.main.async { [weak viewController] in
            viewController?.displayDerivedDataSize(size: formattedSize)
        }
    }
    
    func presentSupportedDevices(models: [DeviceModel]) {
        let viewModels: [DeviceViewModel] = models.map {
            let formattedSize = getFormattedSize(of: $0.size)
            return DeviceViewModel(id: UUID().uuidString, name: $0.url.lastPathComponent, size: formattedSize)
        }
        DispatchQueue.main.async { [weak viewController] in
            viewController?.displaySupportedDevices(viewModels: viewModels)
        }
    }
    
    private func getFormattedSize(of bytesCount: UInt64) -> String {
        let kb: Double = Double(bytesCount / 1024)
        let mb: Double = kb / 1024
        let gb: Double = mb / 1024
        if gb >= 1.0 {
            return String(format: "%.2f", gb) + " GB"
        } else {
            return String(format: "%.2f", mb) + " MB"
        }
    }
}
