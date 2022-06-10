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
                    
                } label: {
                    HStack {
                        Text(viewModel.name)
                        Spacer()
                        Text(viewModel.size)
                    }
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
    let isSelected: Bool
    let isBooted: Bool
    
    var body: some View {
        Group {
            HStack {
                Image(systemName: isBooted ? "poweron" : "poweroff")
                    .frame(width: 12, height: 12, alignment: .center)
                Text(name)
                    .font(Font.system(size: 12))
                    .fontWeight(.regular)
                Spacer()
            }
            .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
        }
        .frame(maxWidth: .infinity)
        .background(isSelected ? Color.accentColor : Color.clear)
        .cornerRadius(6, antialiased: true)
        .contentShape(Rectangle())
    }
}
