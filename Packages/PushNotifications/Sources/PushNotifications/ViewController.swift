//
//  ViewController.swift
//  
//
//  Created by Гавриил Михайлов on 20.05.2022.
//

import AppKit

protocol ViewControllerDisplayLogic: AnyObject {
    
    func displayListOfDevices(viewModels: [DeviceViewModel])
    
    func displaySelectDevice(id: String?)
    
    func displayError(title: String, message: String)
}

protocol ViewControllerDelegate: AnyObject {
    
    func selectDevice(id: String)
    
    func bootDevice(id: String)
    
    func shutdownDevice(id: String)
    
    func send(bundleIdentifier: String, payload: String)
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
    
    override func viewWillAppear() {
        super.viewWillAppear()
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
    
    func displaySelectDevice(id: String?) {
        customView?.configure(deviceID: id)
    }
    
    func displayError(title: String, message: String) {
        let alert = NSAlert()
        alert.informativeText = message
        alert.messageText = title
        alert.runModal()
    }
}

extension ViewController: ViewControllerDelegate {
    
    func selectDevice(id: String) {
        interactor.selectDevice(id: id)
    }
    
    func bootDevice(id: String) {
        interactor.bootDevice(id: id)
    }
    
    func shutdownDevice(id: String) {
        interactor.shutdownDevice(id: id)
    }
    
    func send(bundleIdentifier: String, payload: String) {
        interactor.send(bundleIdentifier: bundleIdentifier, payload: payload)
    }
}
