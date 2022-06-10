//
//  ListView.swift
//  
//
//  Created by Гавриил Михайлов on 05.06.2022.
//

import SwiftUI

final class ListView: NSHostingView<ListViewRootView> {
    
    init(viewState: ListViewState, delegate: ViewControllerDelegate?) {
        super.init(rootView: ListViewRootView(viewState: viewState, delegate: delegate))
    }
    
    @MainActor required init(rootView: ListViewRootView) {
        super.init(rootView: rootView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct ListViewRootView: View {
    
    @ObservedObject var viewState: ListViewState
    weak var delegate: ViewControllerDelegate?

    var body: some View {
        VStack(alignment: .leading) {
            Text(viewState.title)
            List(viewState.rows) { viewModel in
                Button {
                    viewModel.onClick()
                } label: {
                    ButtonLabelView(
                        iconName: viewModel.iconName,
                        title: viewModel.title,
                        isSelected: viewState.selectedRowID == viewModel.id
                    )
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .contextMenu {
                    Button("Reveal in Finder") {
                        viewModel.onReveal()
                    }
                }
            }
            .buttonStyle(.plain)
            .listStyle(PlainListStyle())
            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            .background(Color(nsColor: .controlBackgroundColor))
            .cornerRadius(6, antialiased: true)
        }
    }
}

struct ButtonLabelView: View {
    
    let iconName: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Group {
            HStack {
                Image(systemName: iconName)
                    .frame(width: 12, height: 12, alignment: .center)
                Text(title)
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
