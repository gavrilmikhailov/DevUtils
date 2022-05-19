//
//  SafeArray.swift
//  
//
//  Created by Гавриил Михайлов on 19.05.2022.
//

public extension Array {
    subscript (safe index: Int) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
