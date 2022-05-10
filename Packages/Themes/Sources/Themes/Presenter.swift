//
//  Presenter.swift
//  
//
//  Created by Гавриил Михайлов on 02.05.2022.
//

import Foundation

final class Presenter {
    weak var presenterDelegate: PresenterDelegate?
    
    func presentFiles(files: [FileModel]) {
        let viewModels: [CollectionItemViewModel] = files.map {
            let title = $0.url.deletingPathExtension().lastPathComponent
            return CollectionItemViewModel(title: title, isSelected: $0.isSelected)
        }
        presenterDelegate?.displayFiles(viewModels: viewModels)
    }
    
    func presentError(errorMessage: String) {
        
    }
}
