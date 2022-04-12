//
//  View.swift
//  
//
//  Created by Гавриил Михайлов on 10.04.2022.
//

import AppKit

final class ViewController: NSViewController {
    
    private lazy var collectionView: NSCollectionView = {
        let centeredLayout = CenteredCollectionViewLayout()
//        centeredLayout.itemSize = NSSize(width: 10, height: 10)
//        centeredLayout.horizontalSpacing = 5
//        centeredLayout.verticalSpacing = 5
        let collectionView = NSCollectionView()
        collectionView.collectionViewLayout = centeredLayout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewItem.self, forItemWithIdentifier: .init(type: CollectionViewItem.self))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.wantsLayer = true
        scrollView.contentInsets = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = NSView(frame: .zero)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.wantsLayer = true
        view.addSubview(scrollView)
        scrollView.documentView = collectionView

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    fileprivate func extractedFunc() {
        do {
            let libraryURL = try FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let themesURL = libraryURL
                .appendingPathComponent("Developer")
                .appendingPathComponent("XCode")
                .appendingPathComponent("UserData")
                .appendingPathComponent("FontAndColorThemes")
            
            if !FileManager.default.fileExists(atPath: themesURL.path) {
                try FileManager.default.createDirectory(at: themesURL, withIntermediateDirectories: false)
            }
            let contents = try FileManager.default
                .contentsOfDirectory(at: themesURL, includingPropertiesForKeys: nil)
                .filter { $0.pathExtension == "xccolortheme" }
            
            for file in contents {
                print(file.path)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension ViewController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        1000
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: .init(type: CollectionViewItem.self), for: indexPath)
        item.view.wantsLayer = true
        item.view.layer?.backgroundColor = NSColor.lightGray.cgColor
        return item
    }
}

extension ViewController: NSCollectionViewDelegate {
    
}

extension NSUserInterfaceItemIdentifier {

    init<T>(type: T.Type) {
        self.init(rawValue: String(describing: type))
    }
}
