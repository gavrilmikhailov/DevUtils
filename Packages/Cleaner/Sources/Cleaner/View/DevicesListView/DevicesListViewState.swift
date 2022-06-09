//
//  DevicesListViewState.swift
//  
//
//  Created by Гавриил Михайлов on 09.06.2022.
//

import Combine

final class DevicesListViewState: ObservableObject {
    @Published var rows: [DeviceViewModel] = []
}
