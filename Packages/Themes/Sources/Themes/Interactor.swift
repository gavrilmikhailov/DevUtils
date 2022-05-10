//
//  Interactor.swift
//  
//
//  Created by Гавриил Михайлов on 02.05.2022.
//

import AppKit

final class Interactor {

    private let presenter: Presenter
    private var files: [FileModel]
    
    init(presenter: Presenter) {
        self.presenter = presenter
        self.files = []
    }
    
    func loadFiles() {
        do {
            let libraryURL = try FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let themesURL = libraryURL
                .appendingPathComponent("Developer")
                .appendingPathComponent("XCode")
                .appendingPathComponent("UserData")
                .appendingPathComponent("FontAndColorThemes")

            if !FileManager.default.fileExists(atPath: themesURL.path) {
                try FileManager.default.createDirectory(at: themesURL, withIntermediateDirectories: false)
            }

            let fileURLs = try FileManager.default
                .contentsOfDirectory(at: themesURL, includingPropertiesForKeys: nil)
                .filter { $0.pathExtension == "xccolortheme" }
            files = fileURLs.map {
                FileModel(url: $0, isSelected: false)
            }
            presenter.presentFiles(files: files)
        } catch {
            presenter.presentError(errorMessage: error.localizedDescription)
        }
    }
    
    func selectFiles(at indices: [Int]) {
        for index in 0..<files.count {
            files[index].isSelected = indices.contains(index)
        }
        presenter.presentFiles(files: files)
    }
    
    func revealFilesInFinder() {
        let selectedFiles = files.filter { $0.isSelected }
        if !selectedFiles.isEmpty {
            let fileURLS = selectedFiles.map { $0.url }
            NSWorkspace.shared.activateFileViewerSelecting(fileURLS)
        } else {
            do {
                let libraryURL = try FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let themesURL = libraryURL
                    .appendingPathComponent("Developer")
                    .appendingPathComponent("XCode")
                    .appendingPathComponent("UserData")
                    .appendingPathComponent("FontAndColorThemes")
                NSWorkspace.shared.open(themesURL)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
