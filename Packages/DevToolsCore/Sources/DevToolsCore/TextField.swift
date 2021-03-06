//
//  File.swift
//  
//
//  Created by Гавриил Михайлов on 10.04.2022.
//

import AppKit

public protocol TextFieldDelegate: AnyObject {
    
    func didChangeText(stringValue: String)
    
    func didPaste()
}

public final class TextView: NSTextView {
    
    weak var textFieldDelegate: TextFieldDelegate?
    
    public override func insertNewline(_ sender: Any?) {
        insertNewlineIgnoringFieldEditor(nil)
    }
    
    public override func insertTab(_ sender: Any?) {
        insertTabIgnoringFieldEditor(nil)
    }
    
    public override func paste(_ sender: Any?) {
        super.paste(sender)
        textFieldDelegate?.didPaste()
    }
}


public final class TextFieldCell: NSTextFieldCell {
    
    weak var textFieldDelegate: TextFieldDelegate?
    
    private let textView: TextView
    
    init(textCell string: String, textFieldDelegate: TextFieldDelegate?) {
        textView = TextView()
        textView.textFieldDelegate = textFieldDelegate
        super.init(textCell: string)
        textView.isFieldEditor = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func fieldEditor(for controlView: NSView) -> NSTextView? {
        textView
    }
}

public final class TextField: NSTextField {
    
    weak var textFieldDelegate: TextFieldDelegate?

    public init(textFieldDelegate: TextFieldDelegate?) {
        self.textFieldDelegate = textFieldDelegate
        super.init(frame: .zero)
        cell = TextFieldCell(textCell: "", textFieldDelegate: textFieldDelegate)
        
        // Restoring default properties after cell replacement
        let textField = NSTextField(frame: .zero)
        self.isBordered = textField.isBordered
        self.backgroundColor = textField.backgroundColor
        self.isBezeled = textField.isBezeled
        self.bezelStyle = textField.bezelStyle
        self.isEnabled = textField.isEnabled
        self.isEditable = textField.isEditable
        self.isSelectable = textField.isSelectable
    }
    
    public override func becomeFirstResponder() -> Bool {
        print("TextField became first responder")
        return super.becomeFirstResponder()
    }
    
    public override func resignFirstResponder() -> Bool {
        print("TextField resigned first responder")
        return super.resignFirstResponder()
    }
    
    public override func textDidChange(_ notification: Notification) {
        super.textDidChange(notification)
        textFieldDelegate?.didChangeText(stringValue: stringValue)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
