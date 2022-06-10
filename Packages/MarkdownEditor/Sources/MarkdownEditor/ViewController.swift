//
//  ViewController.swift
//  
//
//  Created by Гавриил Михайлов on 10.06.2022.
//

import AppKit

protocol ViewControllerDisplayLogic: AnyObject {
    
    func displayPreviousDividerOffset(value: Double)
}

protocol ViewControllerDelegate: AnyObject {
    
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
}

extension ViewController: ViewControllerDelegate {
    
    func setDividerOffset(value: CGFloat) {
        interactor.setDividerOffset(value: value)
    }
}
