//
//  ViewController.swift
//  
//
//  Created by Гавриил Михайлов on 05.06.2022.
//

import AppKit

protocol ViewControllerDisplayLogic: AnyObject {
    
    func displayDerivedDataSize(size: String)
}

protocol ViewControllerDelegate: AnyObject {
    
    func cleanDeviredData()
}

final class ViewController: NSViewController {
    
    private let interactor: Interactor
    private lazy var customView = view as? CleanerView
    
    init(interactor: Interactor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowDidBecomeKey(notification:)),
            name: NSWindow.didBecomeKeyNotification,
            object: nil
        )
    }
    
    override func loadView() {
        view = CleanerView(frame: .zero, delegate: self)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        interactor.getDerivedDataSize()
    }
    
    @objc private func windowDidBecomeKey(notification: NSNotification) {
        interactor.getDerivedDataSize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ViewController: ViewControllerDisplayLogic {
    
    func displayDerivedDataSize(size: String) {
        customView?.configure(derivedDataSize: size)
    }
}

extension ViewController: ViewControllerDelegate {
    
    func cleanDeviredData() {
        interactor.cleanDerivedData()
    }
}
