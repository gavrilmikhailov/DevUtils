//
//  View.swift
//  
//
//  Created by Гавриил Михайлов on 20.05.2022.
//

import AppKit

final class PushNotificationsView: NSView {
    
    private lazy var textField: NSTextField = {
        let textField = NSTextField()
        textField.setContentHuggingPriority(.defaultLow, for: .vertical)
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
