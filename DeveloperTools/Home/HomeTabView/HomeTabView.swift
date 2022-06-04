//
//  HomeViewController.swift
//  DevTools
//
//  Created by Гавриил Михайлов on 04.04.2022.
//

import AppKit

final class HomeTabView: NSTabViewController {
    
    private weak var delegate: HomeViewControllerDelegate?

    init(delegate: HomeViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        tabStyle = .unspecified
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabViews()
    }
    
    private func setupTabViews() {
        delegate?.modules.forEach { module in
            let tabViewItem = NSTabViewItem(viewController: module.viewController)
            addTabViewItem(tabViewItem)
        }
    }
}
