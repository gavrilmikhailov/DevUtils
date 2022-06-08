//
//  ViewController.swift
//  
//
//  Created by Гавриил Михайлов on 05.06.2022.
//

import AppKit

protocol ViewControllerDisplayLogic: AnyObject {
    
}

protocol ViewControllerDelegate: AnyObject {
    
}

final class ViewController: NSViewController {
    
    private let interactor: Interactor
    
    init(interactor: Interactor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = CleanerView(frame: .zero, delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ViewController: ViewControllerDisplayLogic {
    
}

extension ViewController: ViewControllerDelegate {
    
}
