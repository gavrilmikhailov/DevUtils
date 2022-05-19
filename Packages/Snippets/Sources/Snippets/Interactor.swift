//
//  Interactor.swift
//  
//
//  Created by Гавриил Михайлов on 19.05.2022.
//

import Foundation
import DevToolsCore

final class Interactor {
    
    private let presenter: Presenter
    private var snippets: [SnippetModel] = []
    
    init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func loadFiles() {
        do {
            let libraryURL = try FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let themesURL = libraryURL
                .appendingPathComponent("Developer")
                .appendingPathComponent("XCode")
                .appendingPathComponent("UserData")
                .appendingPathComponent("CodeSnippets")

            if !FileManager.default.fileExists(atPath: themesURL.path) {
                try FileManager.default.createDirectory(at: themesURL, withIntermediateDirectories: false)
            }

            snippets = try FileManager.default
                .contentsOfDirectory(at: themesURL, includingPropertiesForKeys: nil)
                .filter { $0.pathExtension == "codesnippet" }
                .map { getSnippetModel(url: $0) }
            presenter.presentSnippets(snippets: snippets)
        } catch {
            presenter.presentError(message: error.localizedDescription)
        }
    }
    
    func selectSnippet(at index: Int) {
        guard let snippet = snippets[safe: index] else {
            return
        }
        presenter.presentSnippetContent(snippet: snippet)
    }
    
    private func getSnippetModel(url: URL) -> SnippetModel {
        var id: String?
        var title: String?
        var content: String?
        if let data = FileManager.default.contents(atPath: url.path) {
            if let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] {
                id = plist["IDECodeSnippetIdentifier"] as? String
                title = plist["IDECodeSnippetTitle"] as? String
                content = plist["IDECodeSnippetContents"] as? String
            }
        }
        return SnippetModel(id: id, title: title, content: content, url: url)
    }
}
