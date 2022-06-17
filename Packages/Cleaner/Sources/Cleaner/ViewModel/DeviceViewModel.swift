//
//  DeviceViewModel.swift
//  
//
//  Created by Гавриил Михайлов on 09.06.2022.
//

struct DeviceViewModel: Identifiable {
    let id: String
    let name: String
    let size: String
    let isSelected: Bool
    let onClick: () -> Void
}
