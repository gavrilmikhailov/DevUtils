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
    
    private var supportedDevices: [DeviceModel] = []
    
    init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func getDerivedDataSize() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            do {
                let bytesCount = try FileManager.default
                    .allocatedSizeOfDirectory(at: try self.derivedDataURL)
                self.presenter.presentDerivedDataSize(bytesCount: bytesCount)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getIOSSimulatorCachesSize() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            do {
                let bytesCount = try FileManager.default
                    .allocatedSizeOfDirectory(at: try self.iosSimulatorCachesURL)
                self.presenter.presentIOSSimulatorCachesSize(bytesCount: bytesCount)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func cleanDerivedData() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            do {
                try FileManager.default
                    .contentsOfDirectory(
                        at: try self.derivedDataURL,
                        includingPropertiesForKeys: nil
                    )
                    .forEach { try FileManager.default.removeItem(at: $0) }
                DispatchQueue.main.async {
                    self.getDerivedDataSize()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func cleanSupportedDevices(all: Bool) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            do {
                let urls: [URL]
                if all {
                    urls = self.supportedDevices.map { $0.url }
                } else {
                    urls = self.supportedDevices.filter { $0.isSelected }.map { $0.url }
                }
                try urls.forEach {
                    try FileManager.default.removeItem(at: $0)
                }
                self.getSupportedDevices()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func cleanIOSSImulatorCaches() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            do {
                try FileManager.default
                    .contentsOfDirectory(
                        at: try self.iosSimulatorCachesURL,
                        includingPropertiesForKeys: nil
                    )
                    .forEach { try FileManager.default.removeItem(at: $0) }
                DispatchQueue.main.async {
                    self.getIOSSimulatorCachesSize()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getSupportedDevices() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            do {
                let urls = try FileManager.default.contentsOfDirectory(
                    at: try self.supportedDevicesURL,
                    includingPropertiesForKeys: nil,
                    options: [.skipsHiddenFiles])
                let models: [DeviceModel] = try urls.map {
                    let size = try FileManager.default.allocatedSizeOfDirectory(at: $0)
                    return DeviceModel(url: $0, size: size, isSelected: false)
                }
                self.supportedDevices = models
                self.presenter.presentSupportedDevices(models: models)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func toggleSelection(for device: DeviceModel) {
        supportedDevices = supportedDevices.map {
            if $0 == device {
                return DeviceModel(url: $0.url, size: $0.size, isSelected: !$0.isSelected)
            }
            return $0
        }
        presenter.presentSupportedDevices(models: supportedDevices)
    }
    
    private var derivedDataURL: URL {
        get throws {
            try FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("Developer")
                .appendingPathComponent("XCode")
                .appendingPathComponent("DerivedData")
        }
    }
    
    private var supportedDevicesURL: URL {
        get throws {
            try FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("Developer")
                .appendingPathComponent("XCode")
                .appendingPathComponent("iOS DeviceSupport")
        }
    }
    
    private var iosSimulatorCachesURL: URL {
        get throws {
            try FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("Developer")
                .appendingPathComponent("CoreSimulator")
                .appendingPathComponent("Caches")
        }
    }
}
