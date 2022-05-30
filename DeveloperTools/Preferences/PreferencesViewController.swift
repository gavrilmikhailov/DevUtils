//
//  PreferencesViewController.swift
//  DeveloperTools
//
//  Created by Гавриил Михайлов on 31.05.2022.
//

import AppKit
import FirebaseClient

final class PreferencesViewController: NSViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Preferences"
    }
    
    override func loadView() {
        view = PreferencesView(frame: NSRect(x: 0, y: 0, width: 500, height: 312.5))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCurrentUser()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadCurrentUser() {
        if let currentUser = FirebaseClient.shared.getCurrentUser() {
            print("Email", currentUser.email ?? "nil")
            print("Name", currentUser.name ?? "nil")
        } else {
            print("No current user")
        }
    }
}
