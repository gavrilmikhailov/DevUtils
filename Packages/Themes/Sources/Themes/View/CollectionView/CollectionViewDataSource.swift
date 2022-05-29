//
//  CollectionViewDataSource.swift
//  
//
//  Created by Гавриил Михайлов on 30.04.2022.
//

import AppKit

final class CollectionViewDataSource: NSObject, NSCollectionViewDataSource {

    private unowned let viewModelsDataSource: ViewModelsDataSource
    
    init(viewModelsDataSource: ViewModelsDataSource) {
        self.viewModelsDataSource = viewModelsDataSource
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModelsDataSource.viewModels.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: .init(type: CollectionViewItem.self), for: indexPath) as! CollectionViewItem
        let viewModel = viewModelsDataSource.viewModels[indexPath.item]
        item.configure(with: viewModel)
        return item
    }
}
