//
//  DevicesListViewState.swift
//  
//
//  Created by Гавриил Михайлов on 28.05.2022.
//

import Combine

final class DevicesListViewState: ObservableObject {
    @Published var devices: [DeviceViewModel] = []
    @Published var selectedDeviceID: String? = nil
}
