//
//  View.swift
//  
//
//  Created by Гавриил Михайлов on 26.03.2022.
//

import AppKit
import DevToolsCore

final class TestJsonPrettifierView: NSView {

    private weak var delegate: ViewControllerDelegate?
    
    private lazy var indentaionLabel: NSTextField = {
        let textField = NSTextField(labelWithString: "Indentation")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
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
        textField.font = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        textField.setContentHuggingPriority(.defaultLow, for: .vertical)
        return textField
    }()
    
    private lazy var tabsIndentRadioButton: NSButton = {
        let button = NSButton()
        button.setButtonType(.radio)
        button.target = self
        button.action = #selector(didSelectTabIndentation)
        button.title = "Tab"
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var spacesIndentRadioButton: NSButton = {
        let button = NSButton()
        button.setButtonType(.radio)
        button.target = self
        button.action = #selector(didSelectSpacesIndentation)
        button.title = "Spaces"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var spacesIndentPopUpButton: NSPopUpButton = {
        let popUpButton = NSPopUpButton()
        popUpButton.addItems(withTitles: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"])
        popUpButton.selectItem(at: 1)
        popUpButton.translatesAutoresizingMaskIntoConstraints = false
        return popUpButton
    }()
    
    private lazy var convertButton: NSButton = {
        let button = NSButton(title: "Convert", target: self, action: #selector(didTapConvertButton))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        addSubview(indentaionLabel)
        addSubview(tabsIndentRadioButton)
        addSubview(spacesIndentRadioButton)
        addSubview(spacesIndentPopUpButton)
        addSubview(splitView)
        addSubview(convertButton)
        splitView.addArrangedSubview(inputTextField)
        splitView.addArrangedSubview(outputTextField)
        
        NSLayoutConstraint.activate([
            indentaionLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            indentaionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            
            tabsIndentRadioButton.topAnchor.constraint(equalTo: indentaionLabel.bottomAnchor, constant: 12),
            tabsIndentRadioButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            
            spacesIndentRadioButton.topAnchor.constraint(equalTo: indentaionLabel.bottomAnchor, constant: 12),
            spacesIndentRadioButton.leadingAnchor.constraint(equalTo: tabsIndentRadioButton.trailingAnchor, constant: 12),
            
            spacesIndentPopUpButton.topAnchor.constraint(equalTo: indentaionLabel.bottomAnchor, constant: 12),
            spacesIndentPopUpButton.leadingAnchor.constraint(equalTo: spacesIndentRadioButton.trailingAnchor, constant: 12),
            spacesIndentPopUpButton.widthAnchor.constraint(equalToConstant: 50),
            
            splitView.topAnchor.constraint(equalTo: tabsIndentRadioButton.bottomAnchor, constant: 12),
            splitView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            splitView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            splitView.bottomAnchor.constraint(equalTo: convertButton.topAnchor, constant: -12),
            
            convertButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            convertButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    func configure(previouslyConvertedString: String) {
        inputTextField.stringValue = previouslyConvertedString
        delegate?.formatString(value: previouslyConvertedString)
    }
    
    func configure(dividerOffset: Double) {
        DispatchQueue.main.async { [unowned splitView] in
            splitView.setPosition(splitView.bounds.midX + dividerOffset, ofDividerAt: 0)
        }
    }
    
    func configure(formattedString: String) {
        outputTextField.stringValue = formattedString
    }
    
    func configure(indentationMode: Indentation) {
        switch indentationMode {
        case .spaces(let int):
            spacesIndentRadioButton.state = .on
            tabsIndentRadioButton.state = .off
            spacesIndentPopUpButton.isEnabled = true
            let selectedIndex = spacesIndentPopUpButton.itemTitles.firstIndex(of: String(int))
            spacesIndentPopUpButton.selectItem(at: selectedIndex ?? 0)
        case .tabs:
            spacesIndentRadioButton.state = .off
            tabsIndentRadioButton.state = .on
            spacesIndentPopUpButton.isEnabled = false
        }
    }
    
    @objc private func didSelectTabIndentation() {
        delegate?.setIndentation(mode: .tabs)
    }
    
    @objc private func didSelectSpacesIndentation() {
        delegate?.setIndentation(mode: .spaces(spacesIndentPopUpButton.indexOfSelectedItem + 1))
    }
    
    @objc private func didTapConvertButton() {
        if spacesIndentRadioButton.state == .on {
            didSelectSpacesIndentation()
        }
        delegate?.formatString(value: inputTextField.stringValue)
    }
}

extension TestJsonPrettifierView: TextFieldDelegate {
    func didPaste() {
        didTapConvertButton()
    }
}

extension TestJsonPrettifierView: NSSplitViewDelegate {
    func splitViewDidResizeSubviews(_ notification: Notification) {
        let offset = inputTextField.frame.maxX - splitView.frame.midX + 16
        delegate?.setDividerOffset(value: offset)
    }
}
