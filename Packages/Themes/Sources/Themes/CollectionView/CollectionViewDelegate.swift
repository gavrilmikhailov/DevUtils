//
//  CollectionViewDelegate.swift
//  
//
//  Created by Гавриил Михайлов on 02.05.2022.
//

import AppKit

final class CollectionViewDelegate: NSObject, NSCollectionViewDelegate {
    
    private unowned let viewModelsDataSource: ViewModelsDataSource
    private unowned let viewDelegate: ViewDelegate
    
    init(viewModelsDataSource: ViewModelsDataSource, viewDelegate: ViewDelegate) {
        self.viewModelsDataSource = viewModelsDataSource
        self.viewDelegate = viewDelegate
    }

    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        viewDelegate.didSelectItems(at: indexPaths)
    }

//    func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt indexPath: IndexPath) -> NSPasteboardWriting? {
//        return NSString(string: representableViewModels[indexPath.item].fileURL.path)
//        return NSURL(fileURLWithPath: representableViewModels[indexPath.item].fileURL.path)
//    }
//
//    func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt index: Int) -> NSPasteboardWriting? {
//        return NSString(string: representableViewModels[index].fileURL.path)
//    }
}
