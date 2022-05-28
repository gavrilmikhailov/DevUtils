//
//  ViewController.swift
//  
//
//  Created by Гавриил Михайлов on 20.05.2022.
//

import AppKit

protocol ViewControllerDisplayLogic: AnyObject {
    
    func displayListOfDevices(viewModels: [DeviceViewModel])
}

protocol ViewControllerDelegate: AnyObject {
    
    func selectDevice(id: String)
}

final class ViewController: NSViewController {
    
    private let interactor: Interactor
    
    private lazy var customView = view as? PushNotificationsView

    init(interactor: Interactor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = PushNotificationsView(frame: .zero, delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.loadListOfDevices()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ViewController: ViewControllerDisplayLogic {
    
    func displayListOfDevices(viewModels: [DeviceViewModel]) {
        customView?.configure(viewModels: viewModels)
    }
}

extension ViewController: ViewControllerDelegate {
    
    func selectDevice(id: String) {
        
    }
}
