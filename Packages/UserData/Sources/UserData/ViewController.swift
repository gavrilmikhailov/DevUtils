//
//  ViewController.swift
//  
//
//  Created by Гавриил Михайлов on 05.06.2022.
//

import AppKit

protocol ViewControllerDisplayLogic: AnyObject {
    
    func displayUserThemes(viewModels: [ListViewRowViewModel])
    
    func displayUserSnippets(viewModels: [ListViewRowViewModel])
    
    func displayLastUpdateDate(text: String)
}

protocol ViewControllerDelegate: AnyObject {
    
    func revealInFinder(url: URL)
    
    func exportArchive()
    
    func exportCloud()
    
    func importFiles()
    
    func importCloud()
}

final class ViewController: NSViewController {
    
    private let interactor: Interactor
    private lazy var customView = view as? UserDataView
    
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
        view = UserDataView(frame: .zero, delegate: self)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        loadContent()
    }
    
    @objc private func windowDidBecomeKey(notification: NSNotification) {
        loadContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadContent() {
        interactor.loadFiles()
        interactor.loadLastUpdateDate()
    }
}

extension ViewController: ViewControllerDisplayLogic {
    
    func displayUserThemes(viewModels: [ListViewRowViewModel]) {
        customView?.configure(userThemes: viewModels)
    }
    
    func displayUserSnippets(viewModels: [ListViewRowViewModel]) {
        customView?.configure(userSnippets: viewModels)
    }
    
    func displayLastUpdateDate(text: String) {
        customView?.configure(lastUpdateDate: text)
    }
}

extension ViewController: ViewControllerDelegate {

    func revealInFinder(url: URL) {
        interactor.revealInFinder(url: url)
    }
    
    func exportArchive() {
        interactor.exportArchive()
    }
    
    func exportCloud() {
        if let window = view.window {
            interactor.exportCloud(window: window)
        }
    }
    
    func importFiles() {
        interactor.importFiles()
    }
    
    func importCloud() {
        if let window = view.window {
            interactor.importCloud(window: window)
        }
    }
}
