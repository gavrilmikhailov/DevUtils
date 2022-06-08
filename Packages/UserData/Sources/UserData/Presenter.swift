//
//  Presenter.swift
//  
//
//  Created by Гавриил Михайлов on 05.06.2022.
//

import Foundation

final class Presenter {
    
    weak var viewController: (ViewControllerDisplayLogic & ViewControllerDelegate)?
    
    func presentUserThemes(models: [ThemeModel]) {
        let viewModels: [ListViewRowViewModel] = models.map { model in
            ListViewRowViewModel(
                id: model.id,
                iconName: "paintbrush",
                title: model.url.deletingPathExtension().lastPathComponent,
                onClick: {},
                onReveal: { [weak viewController] in
                    viewController?.revealInFinder(url: model.url)
                }
            )
        }
        viewController?.displayUserThemes(viewModels: viewModels)
    }
    
    func presentUserSnippets(models: [SnippetModel]) {
        let viewModels: [ListViewRowViewModel] = models.map { model in
            ListViewRowViewModel(
                id: model.id,
                iconName: "chevron.left.forwardslash.chevron.right",
                title: model.title ?? "Untitled",
                onClick: {},
                onReveal: { [weak viewController] in
                    viewController?.revealInFinder(url: model.url)
                }
            )
        }
        viewController?.displayUserSnippets(viewModels: viewModels)
    }
    
    func presentLastUploadDate(date: Date?) {
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short
            let stringValue = dateFormatter.string(from: date)
            let text = "Last exported at " + stringValue
            viewController?.displayLastUpdateDate(text: text)
        }
    }
}
