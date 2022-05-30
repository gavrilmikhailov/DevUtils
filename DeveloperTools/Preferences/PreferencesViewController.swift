//
//  PreferencesViewController.swift
//  DeveloperTools
//
//  Created by Гавриил Михайлов on 31.05.2022.
//

import AppKit

protocol PreferencesDisplayLogic: AnyObject {
    func displayUser(viewModel: UserViewModel?)
}

protocol PreferencesViewControllerDelegate: AnyObject {
    func signIn()
    func signOut()
}

final class PreferencesViewController: NSViewController {
    
    private let interactor: PreferencesInteractor
    
    private lazy var customView = view as? PreferencesView
    
    init(interactor: PreferencesInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        title = "Preferences"
    }
    
    override func loadView() {
        view = PreferencesView(frame: NSRect(x: 0, y: 0, width: 500, height: 312.5), delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.loadCurrentUser()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PreferencesViewController: PreferencesDisplayLogic {

    func displayUser(viewModel: UserViewModel?) {
        customView?.configure(user: viewModel)
    }
}

extension PreferencesViewController: PreferencesViewControllerDelegate {
    
    func signIn() {
        guard let window = view.window else { return }
        interactor.signIn(presenting: window)
    }

    func signOut() {
        interactor.signOut()
    }
}
