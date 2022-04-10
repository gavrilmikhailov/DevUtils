//
//  File.swift
//  
//
//  Created by Гавриил Михайлов on 10.04.2022.
//

import AppKit

// the following code makes ALL OF Lists background color transparent:
public extension NSTableView {
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        backgroundColor = NSColor.clear
        if let esv = enclosingScrollView {
            esv.drawsBackground = false
        }
    }
}
