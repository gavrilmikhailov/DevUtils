//
//  ListViewState.swift
//  
//
//  Created by Гавриил Михайлов on 05.06.2022.
//

import Combine

final class ListViewState: ObservableObject {
    @Published var title: String
    @Published var selectedRowID: String?
    @Published var rows: [ListViewRowViewModel]
    
    init(title: String, selectedRowID: String?, rows: [ListViewRowViewModel]) {
        self.title = title
        self.selectedRowID = selectedRowID
        self.rows = rows
    }
}
