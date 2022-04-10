//
//  HomeControlsView.swift
//  DevTools
//
//  Created by Гавриил Михайлов on 04.04.2022.
//

import SwiftUI
import DevToolsCore

final class HomeControlsView: NSHostingView<HomeControlsRootView> {
    
    private weak var delegate: HomeViewControllerDelegate?
    
    init(viewState: HomeControlsViewState, delegate: HomeViewControllerDelegate) {
        self.delegate = delegate
        super.init(rootView: HomeControlsRootView(viewState: viewState, delegate: delegate))
    }
    
    required init(rootView: HomeControlsRootView) {
        super.init(rootView: rootView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct HomeControlsRootView: View {
    
    @ObservedObject var viewState: HomeControlsViewState
    weak var delegate: HomeViewControllerDelegate?
    
    var body: some View {
        List(viewState.rowViewModels) { viewModel in
            Button {
                delegate?.selectTab(at: viewModel.index)
            } label: {
                Group {
                    HStack {
                        Image(nsImage: viewModel.icon)
                            .frame(width: 12, height: 12, alignment: .center)
                        Text(viewModel.title)
                            .font(Font.system(size: 12))
                            .fontWeight(.regular)
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
                }
                .frame(maxWidth: .infinity)
                .background(viewState.selectedRowIndex == viewModel.index ? Color.accentColor : Color.clear)
                .cornerRadius(6, antialiased: true)
                .contentShape(Rectangle())
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .buttonStyle(.plain)
        .listStyle(PlainListStyle())
        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        .background(Color(nsColor: .windowBackgroundColor))
    }
}
