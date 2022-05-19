//
//  ViewController.swift
//  
//
//  Created by Гавриил Михайлов on 27.03.2022.
//

import AppKit

protocol ViewControllerDisplayLogic: AnyObject {
    
    func displaySnippets(viewModels: [SnippetViewModel])
    
    func displaySnippetContent(viewModel: SnippetContentViewModel)

    func displayError(message: String)
}

protocol ViewControllerDelegate: AnyObject {
    
    func selectSnippet(at index: Int)
}

final class ViewController: NSViewController {
    
    private let interactor: Interactor
    
    private lazy var customView = view as? SnippetsView
    
    init(interactor: Interactor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = SnippetsView(frame: .zero, delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.loadFiles()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ViewController: ViewControllerDisplayLogic {

    func displaySnippets(viewModels: [SnippetViewModel]) {
        customView?.configure(snippets: viewModels)
    }
    
    func displaySnippetContent(viewModel: SnippetContentViewModel) {
        customView?.configure(content: viewModel)
    }
    
    func displayError(message: String) {
        let alert = NSAlert()
        alert.informativeText = message
        alert.messageText = "Error"
        alert.runModal()
    }
}

extension ViewController: ViewControllerDelegate {
    
    func selectSnippet(at index: Int) {
        interactor.selectSnippet(at: index)
    }
}
