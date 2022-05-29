//
//  ViewController.swift
//  
//
//  Created by Гавриил Михайлов on 10.04.2022.
//

import AppKit

protocol PresenterDelegate: AnyObject {
    
    func displayFiles(viewModels: [ThemeViewModel])
    
    func displayLastUpdateDate(text: String)
    
    func displayError(message: String)
}

protocol ViewControllerDelegate: AnyObject {

    func didSelectItems(at indexPaths: Set<IndexPath>)
    
    func revealInFinder(id: String)
    
    func uploadFiles()
}

protocol ViewModelsDataSource: AnyObject {
    var viewModels: [CollectionItemViewModel] { get }
}

final class ViewController: NSViewController, ViewModelsDataSource {

    private let interactor: Interactor
    private lazy var customView = view as! ThemesView
    var viewModels: [CollectionItemViewModel]

    init(interactor: Interactor) {
        self.interactor = interactor
        self.viewModels = []
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = ThemesView(frame: .zero, delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.loadFiles()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ViewController: ViewControllerDelegate {
    
    func didSelectItems(at indexPaths: Set<IndexPath>) {
        let indices = indexPaths.map { $0.item }.sorted()
        interactor.selectFiles(at: indices)
    }

    func revealInFinder(id: String) {
        interactor.revealInFinder(id: id)
    }
    
    func uploadFiles() {
        if let window = view.window {
            interactor.uploadFiles(window: window)
        }
    }
}

extension ViewController: PresenterDelegate {

    func displayFiles(viewModels: [ThemeViewModel]) {
        customView.configure(viewModels: viewModels)
    }
    
    func displayLastUpdateDate(text: String) {
        customView.configure(lastUpdateDate: text)
    }
    
    func displayError(message: String) {
        let alert = NSAlert()
        alert.informativeText = message
        alert.messageText = "Error"
        alert.runModal()
    }
}

extension NSUserInterfaceItemIdentifier {

    init<T>(type: T.Type) {
        self.init(rawValue: String(describing: type))
    }
}
