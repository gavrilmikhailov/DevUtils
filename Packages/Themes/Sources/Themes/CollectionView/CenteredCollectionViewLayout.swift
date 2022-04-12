//
//  CenteredCollectionViewLayout.swift
//  
//
//  Created by Гавриил Михайлов on 12.04.2022.
//

import AppKit

final class CenteredCollectionViewLayout: NSCollectionViewLayout {
    
    var itemSize: NSSize = NSSize(width: 80, height: 120)
    var horizontalSpacing: CGFloat = 20
    var verticalSpacing: CGFloat = 20
    
    private var minSpacing: CGFloat = 20
    private var maxSpacing: CGFloat = 40
    
    private var cache: [NSCollectionViewLayoutAttributes] = []
    
    private var numberOfItemsInRow = 0
    private var numberOfRows = 0
    
    override var collectionViewContentSize: NSSize {
        let width: CGFloat = CGFloat(numberOfItemsInRow) * (itemSize.width + horizontalSpacing)
        let height: CGFloat = CGFloat(numberOfRows) * (itemSize.height + verticalSpacing)
        return NSSize(width: width, height: height)
    }
    
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        cache.removeAll()
        numberOfItemsInRow = Int(floor(collectionView.bounds.width / (itemSize.width + horizontalSpacing)))
        numberOfRows = Int(ceil(Double(collectionView.numberOfItems(inSection: 0)) / Double(numberOfItemsInRow)))
        
        for row in 0..<numberOfRows {
            for index in 0..<numberOfItemsInRow {
                let indexPath = IndexPath(item: index + numberOfItemsInRow * row, section: 0)
                let attributes = NSCollectionViewLayoutAttributes(forItemWith: indexPath)
                let frame = NSRect(
                    x: CGFloat(index) * (horizontalSpacing + itemSize.width),
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
