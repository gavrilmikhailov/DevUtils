//
//  CleanerView.swift
//  
//
//  Created by Гавриил Михайлов on 05.06.2022.
//

import AppKit

final class CleanerView: NSView {
    
    private weak var delegate: ViewControllerDelegate?
    
    init(frame: NSRect, delegate: ViewControllerDelegate) {
        self.delegate = delegate
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
