//
//  Presenter.swift
//  
//
//  Created by Гавриил Михайлов on 26.03.2022.
//

final class Presenter {
    
    weak var viewController: ViewControllerDisplayLogic?
    
    func presentPreviouslyConvertedString(value: String?) {
        if let value = value {
            viewController?.displayPreviouslyConvertedString(value: value)
        }
    }
    
    func presentPreviousDividerOffset(value: Double?) {
        if let value = value {
            viewController?.displayPreviousDividerOffset(value: value)
        }
    }
    
    func presentSetIndentation(mode: Indentation) {
        viewController?.displaySetIndentation(mode: mode)
    }
    
    func presentConvertStringToPrettifiedJSON(result: String) {
        viewController?.displayConvertStringToPrettifiedJSON(result: result)
    }
}
