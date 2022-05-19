//
//  CellView.swift
//  
//
//  Created by Гавриил Михайлов on 20.05.2022.
//

import AppKit

final class CellView: NSView {
    
    private lazy var textField: NSTextField = {
        let textField = NSTextField()
        textField.isEditable = false
        textField.isSelectable = false
        textField.isBezeled = false
        textField.drawsBackground = false
        textField.usesSingleLineMode = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(text: String) {
        textField.stringValue = text
    }
}

class VerticallyCenteredTextFieldCell : NSTextFieldCell {
    override func titleRect(forBounds rect: NSRect) -> NSRect {
        var titleRect = super.titleRect(forBounds: rect)

        let minimumHeight = self.cellSize(forBounds: rect).height
        titleRect.origin.y += (titleRect.height - minimumHeight) / 2
        titleRect.size.height = minimumHeight

        return titleRect
    }

    override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
        super.drawInterior(withFrame: titleRect(forBounds: cellFrame), in: controlView)
    }
}
