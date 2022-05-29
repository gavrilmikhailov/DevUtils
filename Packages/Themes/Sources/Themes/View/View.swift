//
//  View.swift
//  
//
//  Created by Гавриил Михайлов on 29.05.2022.
//

import AppKit

final class ThemesView: NSView {
    
    private let collectionDataSource: CollectionViewDataSource
    private let collectionDelegate: CollectionViewDelegate
    private unowned let viewDelegate: ViewDelegate
    
    private lazy var collectionView: NSCollectionView = {
        let centeredLayout = CenteredCollectionViewLayout()
        let collectionView = NSCollectionView()
        collectionView.allowsEmptySelection = true
        collectionView.allowsMultipleSelection = true
        collectionView.collectionViewLayout = centeredLayout
        collectionView.dataSource = collectionDataSource
        collectionView.delegate = collectionDelegate
        collectionView.isSelectable = true
        collectionView.register(CollectionViewItem.self, forItemWithIdentifier: .init(type: CollectionViewItem.self))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let menu = NSMenu()
        menu.addItem(withTitle: "Reveal in Finder", action: #selector(revealInFinder), keyEquivalent: "")
        menu.addItem(withTitle: "Delete", action: nil, keyEquivalent: "")
        collectionView.menu = menu
        return collectionView
    }()
    
    private lazy var scrollView: SomeScrollView = {
        let scrollView = SomeScrollView()
        scrollView.wantsLayer = true
        scrollView.contentInsets = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var exportButton: NSButton = {
        let button = NSButton(title: "Export", target: self, action: #selector(didTapExportButton(_:)))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var signOutButton: NSButton = {
        let button = NSButton(title: "Sign out", target: self, action: #selector(didTapSignOutButton(_:)))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(frame frameRect: NSRect, viewDelegate: ViewDelegate, viewModelsDataSource: ViewModelsDataSource) {
        self.viewDelegate = viewDelegate
        self.collectionDataSource = CollectionViewDataSource(viewModelsDataSource: viewModelsDataSource)
        self.collectionDelegate = CollectionViewDelegate(
            viewModelsDataSource: viewModelsDataSource,
            viewDelegate: viewDelegate
        )
        super.init(frame: frameRect)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        wantsLayer = true
        addSubview(scrollView)
        addSubview(exportButton)
        addSubview(signOutButton)
        scrollView.documentView = collectionView

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            exportButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            exportButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            signOutButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            signOutButton.trailingAnchor.constraint(equalTo: exportButton.leadingAnchor, constant: -12)
        ])
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.collectionViewLayout?.invalidateLayout()
        }
    }
    
    @objc private func revealInFinder() {
        viewDelegate.didTapRevealInFinder()
    }
    
    @objc private func didTapExportButton(_ sender: NSButton) {
        viewDelegate.uploadFiles()
    }
    
    @objc private func didTapSignOutButton(_ sender: NSButton) {
//        FirebaseClient.shared.signOut()
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}
