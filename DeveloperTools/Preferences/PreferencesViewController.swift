//
//  PreferencesViewController.swift
//  DeveloperTools
//
//  Created by Гавриил Михайлов on 31.05.2022.
//

import AppKit

final class PreferencesViewController: NSViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Preferences"
    }
    
    override func loadView() {
        view = PreferencesView(frame: NSRect(x: 0, y: 0, width: 500, height: 312.5))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
