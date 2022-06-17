//
//  DevicesListView.swift
//  
//
//  Created by Гавриил Михайлов on 09.06.2022.
//

import SwiftUI

final class DevicesListView: NSHostingView<DevicesListRootView> {

    init(viewState: DevicesListViewState) {
        super.init(rootView: DevicesListRootView(viewState: viewState))
    }
    
    @MainActor required init(rootView: DevicesListRootView) {
        super.init(rootView: rootView)
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct DevicesListRootView: View {
    
    private let rowHeight: CGFloat = 30
    
    @ObservedObject var viewState: DevicesListViewState
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Supported iOS Devices")
            List(viewState.rows) { viewModel in
                Button {
                    viewModel.onClick()
                } label: {
                    ButtonLabelView(name: viewModel.name, size: viewModel.size, isSelected: viewModel.isSelected)
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .frame(height: rowHeight)
            }
            .frame(height: CGFloat(viewState.rows.count) * rowHeight + 10)
            .buttonStyle(.plain)
            .listStyle(PlainListStyle())
            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            .background(Color(nsColor: .controlBackgroundColor))
            .cornerRadius(6, antialiased: true)
        }
    }
}

struct ButtonLabelView: View {
    
    let name: String
    let size: String
    let isSelected: Bool
    
    var body: some View {
        Group {
            HStack {
                Text(name)
                    .foregroundColor(Color(nsColor: isSelected ? .white : .textColor))
                Spacer()
                Text(size)
                    .foregroundColor(Color(nsColor: isSelected ? .white : .textColor))
            }
            .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
        }
        .frame(maxWidth: .infinity)
        .background(isSelected ? Color.accentColor : Color.clear)
        .cornerRadius(6, antialiased: true)
        .contentShape(Rectangle())
    }
}
