//
//  DeviceModel.swift
//  
//
//  Created by Гавриил Михайлов on 09.06.2022.
//

import Foundation

struct DeviceModel: Equatable {
    let url: URL
    let size: UInt64
    let isSelected: Bool
    
    static func ==(lhs: DeviceModel, rhs: DeviceModel) -> Bool {
        lhs.url == rhs.url
    }
}
