//
//  ViewController.swift
//  DevTools
//
//  Created by Гавриил Михайлов on 05.04.2022.
//

import AppKit
import DevToolsCore
import JsonPrettifier
import PushNotifications
import UserData
import Cleaner
import MarkdownEditor

protocol HomeViewControllerDelegate: AnyObject {
    var modules: [ModuleProtocol] { get }

    func selectTab(at index: Int)
    
    func openPreferences()
}

final class HomeViewController: NSViewController {

    private enum ViewMetrics {
        static let controlsWidth: CGFloat = 200
    }

    let modules: [ModuleProtocol] = [
        PushNotificationsModule(),
        UserDataModule(),
        JsonPrettifierModule(),
        MarkdownEditorModule(),
        CleanerModule(),
    ]
    private var homeControlsViewState: HomeControlsViewState = HomeControlsViewState()
    private weak var tabViewController: HomeTabView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupControlsView()
        setupTabView()
        setupNavigationMenu()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
    }
    
    private func setupControlsView() {
        let homeControlsView = HomeControlsView(viewState: homeControlsViewState, delegate: self)
        view.addSubview(homeControlsView)
        homeControlsView.frame = NSRect(x: 0, y: 0, width: ViewMetrics.controlsWidth, height: view.frame.height)
        homeControlsView.autoresizingMask = [.height]

        homeControlsViewState.rowViewModels = modules.enumerated().map { (index, module) in
            HomeControlsViewRowViewModel(index: index, icon: module.icon, title: module.name)
        }
    }
    
    private func setupTabView() {
        let tabViewController = HomeTabView(delegate: self)
        self.tabViewController = tabViewController
        addChild(tabViewController)
        view.addSubview(tabViewController.view)
        let frame = NSRect(
            x: ViewMetrics.controlsWidth,
            y: 0,
            width: view.frame.width - ViewMetrics.controlsWidth,
            height: view.frame.height)
        tabViewController.view.frame = frame
        tabViewController.view.autoresizingMask = [.width, .height]
    }
    
    private func setupNavigationMenu() {
        let submenu = NSMenu(title: "Navigate")
        for (index, module) in modules.enumerated() {
            let submenuItem = NSMenuItem()
            submenuItem.title = module.name
            submenuItem.action = #selector(navigateToModule(_:))
            submenuItem.keyEquivalent = String(index + 1)
            submenuItem.tag = index
            submenu.addItem(submenuItem)
            if index == 8 { break }
        }
        let menuItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        menuItem.submenu = submenu
        NSApplication.shared.mainMenu?.insertItem(menuItem, at: 3)

        if let preferencesItem = NSApplication.shared.mainMenu?.item(withTitle: "DeveloperTools")?.submenu?.item(withTag: 2) {
            preferencesItem.action = #selector(openPreferences)
            preferencesItem.isEnabled = true
        }
    }
    
    @objc private func navigateToModule(_ sender: NSMenuItem) {
        selectTab(at: sender.tag)
    }
}

extension HomeViewController: HomeViewControllerDelegate {
    
    func selectTab(at index: Int) {
        tabViewController?.selectedTabViewItemIndex = index
        homeControlsViewState.selectedRowIndex = index
    }
    
    @objc func openPreferences() {
        let vc = PreferencesBuilder().build()
        let wc = NSWindowController(window: NSWindow(contentViewController: vc))
        wc.showWindow(self)
    }
}
