//
//  PreferencesBuilder.swift
//  DeveloperTools
//
//  Created by Гавриил Михайлов on 31.05.2022.
//

final class PreferencesBuilder {
    
    func build() -> PreferencesViewController {
        let presenter = PreferencesPresenter()
        let interactor = PreferencesInteractor(presenter: presenter)
        let viewController = PreferencesViewController(interactor: interactor)
        presenter.viewController = viewController
        return viewController
    }
}
