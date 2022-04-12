//
//  CollectionViewItem.swift
//  
//
//  Created by Гавриил Михайлов on 12.04.2022.
//

import AppKit

final class CollectionViewItem: NSCollectionViewItem {
    
    override func loadView() {
        view = NSView(frame: .zero)
    }
}
