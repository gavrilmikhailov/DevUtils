//
//  Interactor.swift
//  
//
//  Created by Гавриил Михайлов on 05.06.2022.
//

import AppKit
import Zip
import FirebaseClient
import DevToolsCore
import UniformTypeIdentifiers

final class Interactor {
    
    private enum SupportedTypes {
        static let themeType: UTType! = UTType(filenameExtension: "xccolortheme")
        static let snippetType: UTType! = UTType(filenameExtension: "codesnippet")
    }
    
    private let presenter: Presenter

    private lazy var debouncer = Debouncer(queue: DispatchQueue.global())

    private var userThemes: [ThemeModel] = []
    private var userSnippets: [SnippetModel] = []
    private var lastUploadDate: Date?
    
    init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func loadFiles() {
        loadLocalThemes()
        loadLocalCodeSnippets()
        presenter.presentUserThemes(models: userThemes)
        presenter.presentUserSnippets(models: userSnippets)
    }
    
    func revealInFinder(url: URL) {
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }
    
    func exportArchive() {
        let panel = NSSavePanel()
        panel.level = .modalPanel
        panel.begin { [weak self] response in
            guard response == .OK, let zipFilePath = panel.url?.appendingPathExtension("zip"), let self = self else {
                return
            }
            do {
                let fileURLs = self.userThemes.map { $0.url } + self.userSnippets.map { $0.url }
                try Zip.zipFiles(paths: fileURLs, zipFilePath: zipFilePath, password: nil) { progress in
                    if progress == 1.0 {
                        DispatchQueue.main.async {
                            NSWorkspace.shared.activateFileViewerSelecting([zipFilePath])
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func exportCloud(window: NSWindow) {
        let fileURLs = userThemes.map { $0.url } + userSnippets.map { $0.url }
        FirebaseClient.shared.uploadFiles(window: window, fileURLs: fileURLs) { [weak self] _, _ in
            self?.debouncer.run {
                DispatchQueue.main.async {
                    self?.updateLastUpdateDate()
                }
            }
        }
    }
    
    func importFiles() {
        let openPanel = NSOpenPanel()
        openPanel.allowedContentTypes = [SupportedTypes.themeType, SupportedTypes.snippetType]
        openPanel.allowsMultipleSelection = true
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        openPanel.canSelectHiddenExtension = true
        openPanel.showsHiddenFiles = true
        openPanel.isExtensionHidden = false
        guard openPanel.runModal() == .OK else {
            return
        }
        do {
            let libraryURL = try FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let themesURL = libraryURL
                .appendingPathComponent("Developer")
                .appendingPathComponent("XCode")
                .appendingPathComponent("UserData")
                .appendingPathComponent("FontAndColorThemes")
            let snippetsURL = libraryURL
                .appendingPathComponent("Developer")
                .appendingPathComponent("XCode")
                .appendingPathComponent("UserData")
                .appendingPathComponent("CodeSnippets")
            if !FileManager.default.fileExists(atPath: themesURL.path) {
                try FileManager.default.createDirectory(at: themesURL, withIntermediateDirectories: false)
            }
            if !FileManager.default.fileExists(atPath: snippetsURL.path) {
                try FileManager.default.createDirectory(at: snippetsURL, withIntermediateDirectories: false)
            }
            try openPanel.urls.forEach {
                if $0.pathExtension == SupportedTypes.themeType.preferredFilenameExtension {
                    let destURL = themesURL.appendingPathComponent($0.lastPathComponent, conformingTo: SupportedTypes.themeType)
                    try FileManager.default.copyItem(at: $0, to: getSafeURLToSaveFile(originalURL: destURL))
                }
                if $0.pathExtension == SupportedTypes.snippetType.preferredFilenameExtension {
                    let destURL = snippetsURL.appendingPathComponent($0.lastPathComponent, conformingTo: SupportedTypes.snippetType)
                    try FileManager.default.copyItem(at: $0, to: getSafeURLToSaveFile(originalURL: destURL))
                }
            }
            NSWorkspace.shared.activateFileViewerSelecting([themesURL])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func importCloud(window: NSWindow) {
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        FirebaseClient.shared.loadFiles(window: window, to: temporaryDirectoryURL) { [weak self] in
            defer {
                try? FileManager.default.removeItem(at: temporaryDirectoryURL)
                self?.loadFiles()
            }
            do {
                let libraryURL = try FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let themesURL = libraryURL
                    .appendingPathComponent("Developer")
                    .appendingPathComponent("XCode")
                    .appendingPathComponent("UserData")
                    .appendingPathComponent("FontAndColorThemes")
                let snippetsURL = libraryURL
                    .appendingPathComponent("Developer")
                    .appendingPathComponent("XCode")
                    .appendingPathComponent("UserData")
                    .appendingPathComponent("CodeSnippets")
                if !FileManager.default.fileExists(atPath: themesURL.path) {
                    try FileManager.default.createDirectory(at: themesURL, withIntermediateDirectories: false)
                }
                if !FileManager.default.fileExists(atPath: snippetsURL.path) {
                    try FileManager.default.createDirectory(at: snippetsURL, withIntermediateDirectories: false)
                }
                for fileURL in try FileManager.default.contentsOfDirectory(at: temporaryDirectoryURL, includingPropertiesForKeys: nil) {
                    if fileURL.pathExtension == SupportedTypes.themeType.preferredFilenameExtension {
                        let destURL = themesURL.appendingPathComponent(fileURL.lastPathComponent, conformingTo: SupportedTypes.themeType)
                        if FileManager.default.fileExists(atPath: destURL.path) {
                            try FileManager.default.removeItem(at: destURL)
                        }
                        try FileManager.default.copyItem(at: fileURL, to: destURL)
                    }
                    if fileURL.pathExtension == SupportedTypes.snippetType.preferredFilenameExtension {
                        let destURL = snippetsURL.appendingPathComponent(fileURL.lastPathComponent, conformingTo: SupportedTypes.snippetType)
                        if FileManager.default.fileExists(atPath: destURL.path) {
                            try FileManager.default.removeItem(at: destURL)
                        }
                        try FileManager.default.copyItem(at: fileURL, to: destURL)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadLastUpdateDate() {
        let timestamp = UserDefaults.standard.double(forKey: "ThemesLastUploadDate")
        if timestamp != 0 {
            lastUploadDate = Date(timeIntervalSince1970: timestamp)
            presenter.presentLastUploadDate(date: lastUploadDate)
        }
    }
    
    private func updateLastUpdateDate() {
        lastUploadDate = Date()
        UserDefaults.standard.set(lastUploadDate!.timeIntervalSince1970, forKey: "ThemesLastUploadDate")
        presenter.presentLastUploadDate(date: lastUploadDate)
    }
    
    private func loadLocalThemes() {
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
            userThemes = fileURLs.map {
                ThemeModel(id: UUID().uuidString, url: $0)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    private func loadLocalCodeSnippets() {
        do {
            let libraryURL = try FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let snippetsURL = libraryURL
                .appendingPathComponent("Developer")
                .appendingPathComponent("XCode")
                .appendingPathComponent("UserData")
                .appendingPathComponent("CodeSnippets")

            if !FileManager.default.fileExists(atPath: snippetsURL.path) {
                try FileManager.default.createDirectory(at: snippetsURL, withIntermediateDirectories: false)
            }

            userSnippets = try FileManager.default
                .contentsOfDirectory(at: snippetsURL, includingPropertiesForKeys: nil)
                .filter { $0.pathExtension == "codesnippet" }
                .map { getSnippetModel(url: $0) }
        } catch {
            print(error.localizedDescription)
        }

    }
    
    private func getSnippetModel(url: URL) -> SnippetModel {
//        var id: String?
        var title: String?
        var content: String?
        if let data = FileManager.default.contents(atPath: url.path) {
            if let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] {
//                id = plist["IDECodeSnippetIdentifier"] as? String
                title = plist["IDECodeSnippetTitle"] as? String
                content = plist["IDECodeSnippetContents"] as? String
            }
        }
        // User appropriate id
        return SnippetModel(id: UUID().uuidString, title: title, content: content, url: url)
    }

    private func getSafeURLToSaveFile(originalURL: URL) -> URL {
        var modifiedURL = originalURL
        var counter = 1
        while FileManager.default.fileExists(atPath: modifiedURL.path) {
            let newName = originalURL
                .deletingPathExtension()
                .lastPathComponent + " (\(counter))"
            modifiedURL = originalURL
                .deletingLastPathComponent()
                .appendingPathComponent(newName)
                .appendingPathExtension(originalURL.pathExtension)
            counter += 1
        }
        return modifiedURL
    }
}
