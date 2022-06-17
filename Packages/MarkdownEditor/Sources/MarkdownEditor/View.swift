//
//  File.swift
//  
//
//  Created by Гавриил Михайлов on 10.06.2022.
//

import AppKit
import DevToolsCore

final class MarkdownEditorView: NSView {
    
    private weak var delegate: ViewControllerDelegate?
    
    private lazy var splitView: NSSplitView = {
        let splitView = NSSplitView()
        splitView.delegate = self
        splitView.isVertical = true
        splitView.translatesAutoresizingMaskIntoConstraints = false
        return splitView
    }()
    
    private lazy var inputTextField: TextField = {
        let textField = TextField(textFieldDelegate: self)
        textField.font = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        textField.focusRingType = .none
        textField.setContentHuggingPriority(.defaultLow, for: .vertical)
        return textField
    }()
    
    private lazy var outputTextField: NSTextField = {
        let textField = NSTextField()
        textField.focusRingType = .none
        textField.isEditable = false
        textField.isSelectable = false
        textField.setContentHuggingPriority(.defaultLow, for: .vertical)
        return textField
    }()
    
    init(frame: NSRect, delegate: ViewControllerDelegate) {
        self.delegate = delegate
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(splitView)
        splitView.addArrangedSubview(inputTextField)
        splitView.addArrangedSubview(outputTextField)
        
        NSLayoutConstraint.activate([
            splitView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            splitView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            splitView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            splitView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    func configure(dividerOffset: Double) {
        DispatchQueue.main.async { [unowned splitView] in
            splitView.setPosition(splitView.bounds.midX + dividerOffset, ofDividerAt: 0)
        }
    }
    
    func configure(attrbutedString: NSAttributedString) {
        outputTextField.attributedStringValue = attrbutedString
    }
}

extension MarkdownEditorView: NSSplitViewDelegate {
    func splitViewDidResizeSubviews(_ notification: Notification) {
        let offset = inputTextField.frame.maxX - splitView.frame.midX + 16
        delegate?.setDividerOffset(value: offset)
    }
}

extension MarkdownEditorView: TextFieldDelegate {

    func didChangeText(stringValue: String) {
        delegate?.editingChanged(text: stringValue)
    }
    
    func didPaste() {
    }
}
