//
//  Presenter.swift
//  
//
//  Created by Гавриил Михайлов on 19.05.2022.
//

final class Presenter {
    
    weak var viewController: ViewController?
    
    func presentSnippets(snippets: [SnippetModel]) {
        let viewModels = snippets.map {
            getViewModel(model: $0)
        }
        viewController?.displaySnippets(viewModels: viewModels)
    }

    func presentSnippetContent(snippet: SnippetModel) {
        let viewModel = getContentViewModel(model: snippet)
        viewController?.displaySnippetContent(viewModel: viewModel)
    }
    
    func presentError(message: String) {
        viewController?.displayError(message: message)
    }
    
    private func getViewModel(model: SnippetModel) -> SnippetViewModel {
        return SnippetViewModel(title: model.title ?? "Untitled")
    }
    
    private func getContentViewModel(model: SnippetModel) -> SnippetContentViewModel {
        return SnippetContentViewModel(content: model.content ?? "No content")
    }
}
