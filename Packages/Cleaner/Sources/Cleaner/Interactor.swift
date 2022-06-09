//
//  Interactor.swift
//  
//
//  Created by Гавриил Михайлов on 05.06.2022.
//

import Foundation
import DevToolsCore

final class Interactor {
    
    private let presenter: Presenter
    
    init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func getDerivedDataSize() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            do {
                let derivedDataURL = try self.getDerivedDataURL()
                let bytesCount = try FileManager.default.allocatedSizeOfDirectory(at: derivedDataURL)
                self.presenter.presentDerivedDataSize(bytes: bytesCount)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func cleanDerivedData() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            do {
                let derivedDataURL = try self.getDerivedDataURL()
                let urls = try FileManager.default.contentsOfDirectory(at: derivedDataURL, includingPropertiesForKeys: nil)
                try urls.forEach {
                    try FileManager.default.removeItem(at: $0)
                }
                DispatchQueue.main.async {
                    self.getDerivedDataSize()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func getDerivedDataURL() throws -> URL {
        let libraryURL = try FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let derivedDataURL = libraryURL
            .appendingPathComponent("Developer")
            .appendingPathComponent("XCode")
            .appendingPathComponent("DerivedData")
        return derivedDataURL
    }
}
