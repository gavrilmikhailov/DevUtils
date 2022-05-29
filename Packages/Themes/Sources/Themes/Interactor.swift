//
//  Interactor.swift
//  
//
//  Created by Гавриил Михайлов on 02.05.2022.
//

import AppKit
import DevToolsCore
import FirebaseClient

final class Interactor {

    private let presenter: Presenter
    private let debouncer: Debouncer

    private var lastUploadDate: Date?
    private var files: [FileModel]
    
    init(presenter: Presenter) {
        self.presenter = presenter
        self.debouncer = Debouncer(queue: DispatchQueue.global())
        self.files = []
        loadLastUpdateDate()
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
                FileModel(id: UUID().uuidString, url: $0, isSelected: false)
            }
            presenter.presentFiles(files: files)
            presenter.presentLastUploadDate(date: lastUploadDate)
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
    
    func revealInFinder(id: String) {
        let selectedFiles = files.filter { $0.id == id }
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
    
    func uploadFiles(window: NSWindow) {
        let fileURLs = files.map { $0.url }
        FirebaseClient.shared.uploadFiles(window: window, fileURLs: fileURLs) { [weak self] _, _ in
            self?.debouncer.run {
                DispatchQueue.main.async {
                    self?.updateLastUpdateDate()
                }
            }
        }
    }
    
    private func loadLastUpdateDate() {
        let timestamp = UserDefaults.standard.double(forKey: "ThemesLastUploadDate")
        if timestamp != 0 {
            lastUploadDate = Date(timeIntervalSince1970: timestamp)
        }
    }
    
    private func updateLastUpdateDate() {
        lastUploadDate = Date()
        UserDefaults.standard.set(lastUploadDate!.timeIntervalSince1970, forKey: "ThemesLastUploadDate")
        presenter.presentLastUploadDate(date: lastUploadDate)
    }
}
