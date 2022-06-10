//
//  ViewController.swift
//  
//
//  Created by Гавриил Михайлов on 10.06.2022.
//

import AppKit

protocol ViewControllerDisplayLogic: AnyObject {
    
    func displayPreviousDividerOffset(value: Double)
    
    func displayFormatted(text: NSAttributedString)
}

protocol ViewControllerDelegate: AnyObject {
    
    func editingChanged(text: String)
    
    func setDividerOffset(value: CGFloat)
}

final class ViewController: NSViewController {
    
    private let interactor: Interactor
    
    private lazy var customView = view as? MarkdownEditorView
    
    init(interactor: Interactor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = MarkdownEditorView(frame: .zero, delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.getPreviousDividerOffset()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ViewController: ViewControllerDisplayLogic {
    
    func displayPreviousDividerOffset(value: Double) {
        customView?.configure(dividerOffset: value)
    }

    func displayFormatted(text: NSAttributedString) {
        customView?.configure(attrbutedString: text)
    }
}

extension ViewController: ViewControllerDelegate {
    
    func editingChanged(text: String) {
        interactor.format(text: text)
    }
    
    func setDividerOffset(value: CGFloat) {
        interactor.setDividerOffset(value: value)
    }
}
