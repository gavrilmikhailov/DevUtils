//
//  PreferencesInteractor.swift
//  DeveloperTools
//
//  Created by Гавриил Михайлов on 31.05.2022.
//

import FirebaseClient
import AppKit

final class PreferencesInteractor {
    
    private let presenter: PreferencesPresenter
    
    init(presenter: PreferencesPresenter) {
        self.presenter = presenter
    }
    
    func loadCurrentUser() {
        let user = FirebaseClient.shared.getCurrentUser()
        presenter.presentUser(user: user)
    }
    
    func signIn(presenting window: NSWindow) {
        FirebaseClient.shared.signIn(presenting: window) { [weak self] in
            self?.loadCurrentUser()
        }
    }
    
    func signOut() {
        FirebaseClient.shared.signOut()
        loadCurrentUser()
    }
}
