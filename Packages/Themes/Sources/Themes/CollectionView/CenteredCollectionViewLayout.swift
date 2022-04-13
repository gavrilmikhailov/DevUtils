//
//  CenteredCollectionViewLayout.swift
//  
//
//  Created by Гавриил Михайлов on 12.04.2022.
//

import AppKit

final class CenteredCollectionViewLayout: NSCollectionViewLayout {
    
    var itemSize: NSSize = NSSize(width: 90, height: 120)
    var verticalSpacing: CGFloat = 20
    
    private var contentInsets = NSEdgeInsets(top: 32.0, left: 32.0, bottom: 32.0, right: 32.0)
    
    private let minSpacing: CGFloat = 32
    private lazy var spacing: CGFloat = minSpacing
    
    private var cache: [NSCollectionViewLayoutAttributes] = []
    
    private var numberOfItemsInRow = 0
    private var numberOfRows = 0
    
    override var collectionViewContentSize: NSSize {
        let width = CGFloat(numberOfItemsInRow) * (itemSize.width + spacing)
        let height = CGFloat(numberOfRows) * (itemSize.height + verticalSpacing)
        return NSSize(width: width, height: height)
    }
    
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        cache.removeAll()
        numberOfItemsInRow = Int(collectionView.bounds.width / (itemSize.width + minSpacing))
        numberOfRows = Int(ceil(Double(collectionView.numberOfItems(inSection: 0)) / Double(numberOfItemsInRow)))
        
        let itemsWidth = CGFloat(numberOfItemsInRow) * itemSize.width
        let totalAvailableSpacing = collectionView.bounds.width - itemsWidth
        spacing = totalAvailableSpacing / CGFloat(numberOfItemsInRow)

        for row in 0..<numberOfRows {
            for index in 0..<numberOfItemsInRow {
                let indexPath = IndexPath(item: index + numberOfItemsInRow * row, section: 0)
                let attributes = NSCollectionViewLayoutAttributes(forItemWith: indexPath)
                let frame = NSRect(
                    x: CGFloat(index) * (itemSize.width + spacing) + spacing / 2,
                    y: CGFloat(row) * (itemSize.height + verticalSpacing),
                    width: itemSize.width,
                    height: itemSize.height)
                attributes.frame = frame
                cache.append(attributes)
            }
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        var visibleLayoutAttributes: [NSCollectionViewLayoutAttributes] = []

        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: NSRect) -> Bool {
        true
    }
}