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
        let viewModels: [ThemeViewModel] = files.map {
            let name = $0.url.deletingPathExtension().lastPathComponent
            return ThemeViewModel(id: $0.url.path, name: name, isSelected: $0.isSelected)
        }
        presenterDelegate?.displayFiles(viewModels: viewModels)
    }
    
    func presentLastUploadDate(date: Date?) {
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short
            let stringValue = dateFormatter.string(from: date)
            let text = "Last updated at " + stringValue
            presenterDelegate?.displayLastUpdateDate(text: text)
        }
    }
    
    func presentError(errorMessage: String) {
        presenterDelegate?.displayError(message: errorMessage)
    }
}
