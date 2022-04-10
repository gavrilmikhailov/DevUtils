//
//  View.swift
//  
//
//  Created by Гавриил Михайлов on 10.04.2022.
//

import AppKit

final class ViewController: NSViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = NSView(frame: .zero)
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.green.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
