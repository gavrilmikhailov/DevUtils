//
//  CollectionViewItem.swift
//  
//
//  Created by Гавриил Михайлов on 12.04.2022.
//

import AppKit
import SwiftUI

final class CollectionViewItem: NSCollectionViewItem, ObservableObject {
    
    @Published var itemTitle: String = ""
    @Published var isItemSelected: Bool = false
    
    private lazy var customView = (view as? NSHostingView<CollectionViewItemView>)?.rootView

    override func loadView() {
        view = NSHostingView<CollectionViewItemView>(rootView: CollectionViewItemView(item: self))
    }
    
    func configure(with viewModel: CollectionItemViewModel) {
        self.itemTitle = viewModel.title
        self.isItemSelected = viewModel.isSelected
    }
}

fileprivate struct CollectionViewItemView: View {
    
    @ObservedObject var item: CollectionViewItem
    
    var body: some View {
        VStack {
            ZStack {
                item.isItemSelected ? Color(NSColor.lightGray.withAlphaComponent(0.3)) : Color.clear
                Image(systemName: "paintbrush")
                    .resizable()
                    .frame(width: 42, height: 47, alignment: .center)
            }
            .cornerRadius(4, antialiased: true)
            Text(item.itemTitle)
                .multilineTextAlignment(.center)
                .fixedSize()
                .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
                .background(item.isItemSelected ? Color(NSColor.selectedContentBackgroundColor) : Color.clear)
                .cornerRadius(4, antialiased: true)
        }
        .contentShape(Rectangle())
    }
}
