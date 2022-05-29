//
//  ViewController.swift
//  
//
//  Created by Гавриил Михайлов on 10.04.2022.
//

import AppKit

protocol PresenterDelegate: AnyObject {
    
    func displayFiles(viewModels: [CollectionItemViewModel])
}

protocol ViewDelegate: AnyObject {

    func didSelectItems(at indexPaths: Set<IndexPath>)
    
    func didTapRevealInFinder()
    
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
        view = ThemesView(frame: .zero, viewDelegate: self, viewModelsDataSource: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.loadFiles()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ViewController: ViewDelegate {
    
    func didSelectItems(at indexPaths: Set<IndexPath>) {
        let indices = indexPaths.map { $0.item }.sorted()
        interactor.selectFiles(at: indices)
    }

    func didTapRevealInFinder() {
        interactor.revealFilesInFinder()
    }
    
    func uploadFiles() {
        if let window = view.window {
            interactor.uploadFiles(window: window)
        }
    }
}

extension ViewController: PresenterDelegate {

    func displayFiles(viewModels: [CollectionItemViewModel]) {
        self.viewModels = viewModels
        customView.reloadData()
    }
}

extension NSUserInterfaceItemIdentifier {

    init<T>(type: T.Type) {
        self.init(rawValue: String(describing: type))
    }
}
