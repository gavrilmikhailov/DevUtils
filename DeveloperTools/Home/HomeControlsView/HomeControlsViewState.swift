//
//  HomeControlsViewState.swift
//  DevTools
//
//  Created by Гавриил Михайлов on 06.04.2022.
//

import SwiftUI

final class HomeControlsViewState: ObservableObject {
    @Published var rowViewModels: [HomeControlsViewRowViewModel] = []
    @Published var selectedRowIndex: Int = 0
}

struct HomeControlsViewRowViewModel {
    let index: Int
    let icon: NSImage
    let title: String
}

extension HomeControlsViewRowViewModel: Identifiable {
    var id: Int {
        index
    }
}
