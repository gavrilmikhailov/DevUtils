//
//  Presenter.swift
//  
//
//  Created by Гавриил Михайлов on 05.06.2022.
//

import Foundation

final class Presenter {
    
    weak var viewController: ViewControllerDisplayLogic?

    func presentDerivedDataSize(bytes: UInt64) {
        var result = ""
        let kb: Double = Double(bytes / 1024)
        let mb: Double = kb / 1024
        let gb: Double = mb / 1024
        print("B", bytes)
        print("KB", kb)
        print("MB", mb)
        print("GB", gb)
        if gb >= 1.0 {
            result = String(format: "%.2f", gb) + " GB"
        } else {
            result = String(format: "%.2f", mb) + " MB"
        }
        DispatchQueue.main.async { [weak viewController] in
            viewController?.displayDerivedDataSize(size: result)
        }
    }
}
