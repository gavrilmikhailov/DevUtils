//
//  DevicesListViewState.swift
//  
//
//  Created by Гавриил Михайлов on 28.05.2022.
//

import SwiftUI

final class DevicesListViewState: ObservableObject {
    @Published var devices: [DeviceViewModel] = []
    @Published var selectedDeviceID: String? = nil
}
