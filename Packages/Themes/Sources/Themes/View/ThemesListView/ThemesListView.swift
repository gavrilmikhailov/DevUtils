//
//  ThemesListView.swift
//  
//
//  Created by Гавриил Михайлов on 29.05.2022.
//

import SwiftUI

final class ThemesListView: NSHostingView<ThemesListRootView> {
    
    init(viewState: ThemesListViewState, delegate: ViewControllerDelegate?) {
        super.init(rootView: ThemesListRootView(viewState: viewState, delegate: delegate))
    }

    @MainActor required init(rootView: ThemesListRootView) {
        super.init(rootView: rootView)
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct ThemesListRootView: View {
    
    @ObservedObject var viewState: ThemesListViewState
    weak var delegate: ViewControllerDelegate?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Themes")
            List(viewState.themes) { viewModel in
                Button {
//                    delegate?.selectDevice(id: viewModel.id)
                } label: {
                    ButtonLabelView(
                        name: viewModel.name,
                        isSelected: viewState.selectedThemeID == viewModel.id
                    )
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .contextMenu {
                    Button("Reveal in Finder") {
                        delegate?.revealInFinder(id: viewModel.id)
                    }
                }
            }
            .buttonStyle(.plain)
            .listStyle(PlainListStyle())
            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            .background(Color(nsColor: .windowBackgroundColor))
            .cornerRadius(6, antialiased: true)
        }
    }
}

struct ButtonLabelView: View {
    
    let name: String
    let isSelected: Bool
    
    var body: some View {
        Group {
            HStack {
                Image(systemName: "paintbrush")
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
