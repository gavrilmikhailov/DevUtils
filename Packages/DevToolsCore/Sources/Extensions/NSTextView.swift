//
//  File.swift
//  
//
//  Created by Гавриил Михайлов on 10.04.2022.
//

import AppKit

// the following code makes ALL OF TextEditors background color transparent:
public extension NSTextView {
    override var frame: CGRect {
        didSet {
            backgroundColor = .clear
            drawsBackground = true
        }
    }
}
