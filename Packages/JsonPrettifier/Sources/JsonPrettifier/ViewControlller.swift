//
//  MainViewController.swift
//  
//
//  Created by Гавриил Михайлов on 26.03.2022.
//

import AppKit
import DevToolsCore

protocol ViewControllerDisplayLogic: AnyObject {
    func displayPreviouslyConvertedString(value: String)
    func displayPreviousDividerOffset(value: Double)
    func displaySetIndentation(mode: Indentation)
    func displayConvertStringToPrettifiedJSON(result: String)
}

protocol ViewControllerDelegate: AnyObject {
    func formatString(value: String)
    func setIndentation(mode: Indentation)
    func setDividerOffset(value: CGFloat)
}

final class ViewController: NSViewController {
    
    private let interactor: Interactor

    private lazy var customView = view as! JsonPrettifierView

    init(title: String, interactor: Interactor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    override func loadView() {
        view = JsonPrettifierView(frame: .zero, delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.setIndentation(mode: nil)
        interactor.getPreviousDividerOffset()
        interactor.getPreviouslyConvertedString()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ViewController: ViewControllerDisplayLogic {
    func displayPreviouslyConvertedString(value: String) {
        customView.configure(previouslyConvertedString: value)
    }
    
    func displayPreviousDividerOffset(value: Double) {
        customView.configure(dividerOffset: value)
    }
    
    func displaySetIndentation(mode: Indentation) {
        customView.configure(indentationMode: mode)
    }
    
    func displayConvertStringToPrettifiedJSON(result: String) {
        DispatchQueue.main.async { [weak customView] in
            customView?.configure(formattedString: result)
        }
    }
}

extension ViewController: ViewControllerDelegate {
    func formatString(value: String) {
        interactor.convertStringToPrettifiedJSON(str: value)
    }
    
    func setIndentation(mode: Indentation) {
        interactor.setIndentation(mode: mode)
    }
    
    func setDividerOffset(value: CGFloat) {
        interactor.setDividerOffset(value: value)
    }
}
