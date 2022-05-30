//
//  PreferencesPresenter.swift
//  DeveloperTools
//
//  Created by Гавриил Михайлов on 31.05.2022.
//

import FirebaseClient

final class PreferencesPresenter {
    
    weak var viewController: PreferencesDisplayLogic?
    
    func presentUser(user: UserModel?) {
        if let user = user {
            let viewModel = UserViewModel(name: user.name, email: user.email, photo: user.photo)
            viewController?.displayUser(viewModel: viewModel)
        } else {
            viewController?.displayUser(viewModel: nil)
        }
    }
}
