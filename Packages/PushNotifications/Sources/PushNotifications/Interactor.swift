//
//  Interactor.swift
//  
//
//  Created by Гавриил Михайлов on 28.05.2022.
//

import Foundation

final class Interactor {
    
    private let presenter: Presenter

    private var selectedDeviceID: String?
    private var appBundleIdentifier: String?
    
    init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func loadListOfDevices() {
        DispatchQueue.global().async { [presenter] in
            let command = "xcrun simctl list -j devices"
            guard let data = command.runAsCommand()?.data(using: .utf8) else {
                return
            }
            do {
                let model = try JSONDecoder().decode(DevicesModel.self, from: data)
                DispatchQueue.main.async {
                    presenter.presentListOfDevices(devicesModel: model)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func selectDevice(id: String) {
        selectedDeviceID = selectedDeviceID == id ? nil : id
        presenter.presentSelectDevice(id: selectedDeviceID)
    }
    
    func bootDevice(id: String) {
        let openSimulatorCommand = "open -a Simulator --background"
        let bootDeviceCommand = "xcrun simctl boot \(id)"
        openSimulatorCommand.runAsCommand()
        bootDeviceCommand.runAsCommand()
        loadListOfDevices()
    }
    
    func shutdownDevice(id: String) {
        let shutdownCommand = "xcrun simctl shutdown \(id)"
        shutdownCommand.runAsCommand()
        loadListOfDevices()
    }
    
    func send(bundleIdentifier: String, payload: String) {
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let temporaryFileName = UUID().uuidString
        let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(temporaryFileName)
        guard let selectedDeviceID = selectedDeviceID else {
            return presenter.presentError(title: "Error", message: "Target device is not selected")
        }
        guard !bundleIdentifier.trimmingCharacters(in: .whitespaces).isEmpty else {
            return presenter.presentError(title: "Error", message: "Target app's bundle identifier is not specified")
        }
        guard let data = payload.data(using: .utf8) else {
            return presenter.presentError(title: "Error", message: "Unable to form data from payload")
        }
        do {
            try data.write(to: temporaryFileURL, options: .atomic)
        } catch {
            presenter.presentError(title: "Error", message: error.localizedDescription)
        }
        let sendNotificationCommand = "xcrun simctl push \(selectedDeviceID) \(bundleIdentifier) \(temporaryFileURL.path)"
        print(sendNotificationCommand)
        if let output = sendNotificationCommand.runAsCommand() {
            print(output)
        }
    }
}


public extension String {
    
    @discardableResult
    func runAsCommand() -> String? {
        let pipe = Pipe()
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", String(format:"%@", self)]
        task.standardOutput = pipe
        let file = pipe.fileHandleForReading
        task.launch()
        let result = NSString(
            data: file.readDataToEndOfFile(),
            encoding: Encoding.utf8.rawValue
        )
        return result as? String
    }
}
