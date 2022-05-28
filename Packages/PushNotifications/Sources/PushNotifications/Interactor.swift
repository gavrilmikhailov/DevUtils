//
//  Interactor.swift
//  
//
//  Created by Гавриил Михайлов on 28.05.2022.
//

import Foundation

final class Interactor {
    
    private let presenter: Presenter
    
    init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func loadListOfDevices() {
        DispatchQueue.global().async { [presenter] in
            let command = "xcrun simctl list devices"// | grep Booted"
            if let output = command.runAsCommand() {
                DispatchQueue.main.async {
                    presenter.presentListOfDevices(output: output)
                }
            }
        }
    }
}


extension String {
    func runAsCommand() -> String? {
        let pipe = Pipe()
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", String(format:"%@", self)]
        task.standardOutput = pipe
        let file = pipe.fileHandleForReading
        task.launch()
        if let result = NSString(data: file.readDataToEndOfFile(), encoding: String.Encoding.utf8.rawValue) {
            return result as String
        } else {
            return nil
        }
    }
}
