//
//  View.swift
//  
//
//  Created by Гавриил Михайлов on 26.03.2022.
//

import AppKit
import DevToolsCore
import SharedViews

final class TestJsonPrettifierView: NSView {
    
    private weak var viewController: ViewController?
    
    lazy var splitView: NSSplitView = {
        let splitView = NSSplitView()
        splitView.delegate = viewController
        splitView.isVertical = true
        splitView.translatesAutoresizingMaskIntoConstraints = false
        return splitView
    }()
    
    lazy var inputTextField: TextField = {
        let textField = TextField(textFieldDelegate: viewController)
        textField.font = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        textField.focusRingType = .none
        textField.setContentHuggingPriority(.defaultLow, for: .vertical)
        return textField
    }()
    
    lazy var outputTextField: NSTextField = {
        let textField = NSTextField()
        textField.focusRingType = .none
        textField.font = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        textField.setContentHuggingPriority(.defaultLow, for: .vertical)
        return textField
    }()
    
    lazy var convertButton: NSButton = {
        let button = NSButton(title: "Convert", target: nil, action: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(frame: NSRect, viewController: ViewController) {
        self.viewController = viewController
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        splitView.addArrangedSubview(inputTextField)
        splitView.addArrangedSubview(outputTextField)
        addSubview(splitView)
        addSubview(convertButton)
        
        NSLayoutConstraint.activate([
            splitView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            splitView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            splitView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            splitView.bottomAnchor.constraint(equalTo: convertButton.topAnchor, constant: -10),
            
            convertButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            convertButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        DispatchQueue.main.async { [unowned splitView] in
            let dividerOffset = UserDefaults.standard.double(forKey: "dividerOffset")
            splitView.setPosition(splitView.bounds.midX + dividerOffset, ofDividerAt: 0)
        }
    }
}
