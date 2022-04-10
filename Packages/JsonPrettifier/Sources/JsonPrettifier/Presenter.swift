//
//  File.swift
//  
//
//  Created by Гавриил Михайлов on 26.03.2022.
//

final class Presenter {
    
    weak var viewController: ViewController?
    
    func presentConvertStringToPrettifiedJSON(result: String) {
        viewController?.displayConvertStringToPrettifiedJSON(result: result)
    }
}
