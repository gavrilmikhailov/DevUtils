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
        ZStack(alignment: .bottomTrailing) {
            List(viewState.rowViewModels) { viewModel in
                ModuleButton(
                    icon: viewModel.icon,
                    title: viewModel.title,
                    isSelected: viewState.selectedRowIndex == viewModel.index,
                    onClick: {
                        delegate?.selectTab(at: viewModel.index)
                    }
                )
            }
            .buttonStyle(.plain)
            .listStyle(PlainListStyle())
            .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
            .background(Color(nsColor: .windowBackgroundColor))
            PreferencesButton {
                delegate?.openPreferences()
            }
        }
    }
}

struct ModuleButton: View {
    let icon: NSImage
    let title: String
    let isSelected: Bool
    let onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            Group {
                HStack {
                    Image(nsImage: icon)
                        .frame(width: 12, height: 12, alignment: .center)
                        .foregroundColor(Color(nsColor: isSelected ? .white : .textColor))
                    Text(title)
                        .font(Font.system(size: 12))
                        .fontWeight(.regular)
                        .foregroundColor(Color(nsColor: isSelected ? .white : .textColor))
                    Spacer()
                }
                .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
            }
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.accentColor : Color.clear)
            .cornerRadius(6, antialiased: true)
            .contentShape(Rectangle())
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

struct PreferencesButton: View {
    let onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            Image(systemName: "gear")
        }
        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
    }
}
