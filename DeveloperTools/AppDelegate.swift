//
//  AppDelegate.swift
//  DeveloperTools
//
//  Created by Гавриил Михайлов on 09.04.2022.
//

import Cocoa
import FirebaseClient

@main
final class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        FirebaseClient.shared.initializeApp()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    func application(_ application: NSApplication, open urls: [URL]) {
        FirebaseClient.shared.handleOpen(url: urls[0])
    }
}
