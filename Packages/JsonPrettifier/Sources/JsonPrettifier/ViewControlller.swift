//
//  MainViewController.swift
//  
//
//  Created by Гавриил Михайлов on 26.03.2022.
//

import AppKit
import DevToolsCore
import Views

final class ViewController: NSViewController {
    
    private let interactor: Interactor
    private let debouncer = Debouncer(queue: DispatchQueue.main)
    private lazy var customView = view as! TestJsonPrettifierView

    init(title: String, interactor: Interactor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    override func loadView() {
        let customView = TestJsonPrettifierView(frame: .zero, viewController: self)
        customView.convertButton.target = self
        customView.convertButton.action = #selector(didTapConvert(_:))
        self.view = customView
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    @objc private func didTapConvert(_ sender: NSButton) {
        convertStringToPrettifiedJSON()
    }
    
    func displayConvertStringToPrettifiedJSON(result: String) {
        DispatchQueue.main.async { [weak self] in
            self?.customView.outputTextField.stringValue = result
        }
    }
    
    private func convertStringToPrettifiedJSON() {
        interactor.convertStringToPrettifiedJSON(str: customView.inputTextField.stringValue)
    }
}

extension ViewController: TextFieldDelegate {
    
    func didPaste() {
        convertStringToPrettifiedJSON()
    }
}

extension ViewController: NSSplitViewDelegate {
    
    func splitViewDidResizeSubviews(_ notification: Notification) {
        debouncer.run { [weak self] in
            guard let self = self else { return }
            let offset = self.customView.inputTextField.frame.maxX - self.customView.splitView.frame.midX + 16
            UserDefaults.standard.set(offset, forKey: "dividerOffset")
        }
    }
}
