//
//  View.swift
//  
//
//  Created by Гавриил Михайлов on 10.04.2022.
//

import AppKit

final class CenteredCollectionViewLayout: NSCollectionViewLayout {
    
    private var cache: [NSCollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        return collectionView.bounds.width
    }
    
    override var collectionViewContentSize: NSSize {
        NSSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else {
            return
        }
        for index in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = NSCollectionViewLayoutAttributes(forItemWith: indexPath)
            attributes.frame = NSRect(x: index * 100, y: 0, width: 80, height: 120)
            cache.append(attributes)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        cache[indexPath.item]
    }
    
    override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        var visibleLayoutAttributes: [NSCollectionViewLayoutAttributes] = []

        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
}

final class ViewController: NSViewController {
    
    private lazy var collectionView: NSCollectionView = {
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 60, height: 60)
        flowLayout.minimumLineSpacing = 3
        flowLayout.minimumInteritemSpacing = 3
        flowLayout.sectionInset = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let gridLayout = NSCollectionViewGridLayout()
        gridLayout.minimumLineSpacing = 20
        gridLayout.minimumInteritemSpacing = 32
        gridLayout.maximumItemSize = NSSize(width: 80, height: 100)
        gridLayout.minimumItemSize = NSSize(width: 80, height: 100)
        let collectionView = NSCollectionView()
        collectionView.collectionViewLayout = CenteredCollectionViewLayout()
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
//        scrollView.addSubview(collectionView)
        scrollView.documentView = collectionView

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
//            collectionView.topAnchor.constraint(equalTo: scrollView.co.topAnchor, constant: 32),
//            collectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 32),
//            collectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -32),
//            collectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -32)
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
        50
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: .init(type: CollectionViewItem.self), for: indexPath)
        item.view.wantsLayer = true
        item.view.layer?.backgroundColor = NSColor.green.cgColor
        return item
    }
}

extension ViewController: NSCollectionViewDelegate {
    
}

final class CollectionViewItem: NSCollectionViewItem {
    
    override func loadView() {
        view = NSView(frame: .zero)
    }
}

extension NSUserInterfaceItemIdentifier {

    init<T>(type: T.Type) {
        self.init(rawValue: String(describing: type))
    }
}
