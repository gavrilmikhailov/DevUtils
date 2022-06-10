//
//  Presenter.swift
//  
//
//  Created by Гавриил Михайлов on 10.06.2022.
//

import Foundation

final class Presenter {
    
    weak var viewController: ViewControllerDisplayLogic?
    
    func presentPreviousDividerOffset(value: Double?) {
        if let value = value {
            viewController?.displayPreviousDividerOffset(value: value)
        }
    }
    
    func presentFormatted(text: NSAttributedString) {
        viewController?.displayFormatted(text: text)
    }
}
