//
//  ViewController.swift
//  
//
//  Created by Гавриил Михайлов on 20.05.2022.
//

import AppKit

final class ViewController: NSViewController {
    
    private lazy var customView = view as? PushNotificationsView

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = PushNotificationsView(frame: .zero)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadListOfDevices()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadListOfDevices() {
        if let output = "xcrun simctl list devices".runAsCommand() {        
            customView?.configure(text: output)
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
