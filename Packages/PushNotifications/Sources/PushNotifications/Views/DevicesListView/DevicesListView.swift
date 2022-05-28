//
//  DevicesListView.swift
//  
//
//  Created by Гавриил Михайлов on 28.05.2022.
//

import SwiftUI

final class DevicesListView: NSHostingView<DevicesListRootView> {
    
    init(viewState: DevicesListViewState, delegate: ViewControllerDelegate?) {
        super.init(rootView: DevicesListRootView(viewState: viewState, delegate: delegate))
    }
    
    @MainActor required init(rootView: DevicesListRootView) {
        super.init(rootView: rootView)
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct DevicesListRootView: View {
    
    @ObservedObject var viewState: DevicesListViewState
    weak var delegate: ViewControllerDelegate?
    
    var body: some View {
        List(viewState.devices) { viewModel in
            Button {
                delegate?.selectDevice(id: viewModel.id)
            } label: {
                ButtonLabelView(name: viewModel.name, isSelected: viewState.selectedDeviceID == viewModel.id)
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .buttonStyle(.plain)
        .listStyle(PlainListStyle())
        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        .background(Color(nsColor: .windowBackgroundColor))
    }
}

struct ButtonLabelView: View {
    
    let name: String
    let isSelected: Bool
    
    var body: some View {
        Group {
            HStack {
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
