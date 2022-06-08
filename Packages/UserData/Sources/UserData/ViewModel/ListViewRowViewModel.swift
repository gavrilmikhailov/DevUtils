//
//  ListViewRowViewModel.swift
//  
//
//  Created by Гавриил Михайлов on 05.06.2022.
//

struct ListViewRowViewModel: Identifiable {
    let id: String
    let iconName: String
    let title: String
    let onClick: () -> Void
    let onReveal: () -> Void
}
