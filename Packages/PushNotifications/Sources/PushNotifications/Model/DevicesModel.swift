//
//  DevicesModel.swift
//  
//
//  Created by Гавриил Михайлов on 29.05.2022.
//

struct DevicesModel: Decodable {
    let devices: [String: [DeviceModel]]
}

struct DeviceModel: Decodable {
    let udid: String
    let isAvailable: Bool
    let name: String
    let state: DeviceState
}

enum DeviceState: String, Decodable {
    case shutdown = "Shutdown"
    case booted = "Booted"
}
