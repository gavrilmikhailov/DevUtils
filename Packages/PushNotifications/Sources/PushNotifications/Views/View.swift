//
//  View.swift
//  
//
//  Created by Гавриил Михайлов on 20.05.2022.
//

import DevToolsCore
import AppKit

final class PushNotificationsView: NSView {
    
    private let devicesListViewState = DevicesListViewState()
    private weak var delegate: ViewControllerDelegate?

    private lazy var devicesListView: DevicesListView = {
        let view = DevicesListView(viewState: devicesListViewState, delegate: delegate)
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var appBundleIdenfitierLabel: NSTextField = {
        let textField = NSTextField(labelWithString: "App bundle identifier")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var appBundleIdenfitierTextField: NSTextField = {
        let textField = NSTextField()
        textField.placeholderString = "com.apple.DocumentsApp"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var jsonPayloadLabel: NSTextField = {
        let textField = NSTextField(labelWithString: "Notification payload")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var jsonPayloadTextField: NSTextField = {
        let textField = TextField(textFieldDelegate: nil)
        textField.placeholderString = getPayloadPlaceholder()
        textField.setContentHuggingPriority(.defaultLow, for: .vertical)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var sendButton: NSButton = {
        let button = NSButton(title: "Send", target: self, action: #selector(didTapSendButton(_:)))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(frame frameRect: NSRect, delegate: ViewControllerDelegate) {
        self.delegate = delegate
        super.init(frame: frameRect)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(devicesListView)
        addSubview(appBundleIdenfitierLabel)
        addSubview(appBundleIdenfitierTextField)
        addSubview(jsonPayloadLabel)
        addSubview(jsonPayloadTextField)
        addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            devicesListView.topAnchor.constraint(equalTo: topAnchor),
            devicesListView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            devicesListView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            devicesListView.widthAnchor.constraint(equalToConstant: 280),
            
            appBundleIdenfitierLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            appBundleIdenfitierLabel.leadingAnchor.constraint(equalTo: devicesListView.trailingAnchor, constant: 12),
            appBundleIdenfitierLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            appBundleIdenfitierTextField.topAnchor.constraint(equalTo: appBundleIdenfitierLabel.bottomAnchor, constant: 10),
            appBundleIdenfitierTextField.leadingAnchor.constraint(equalTo: devicesListView.trailingAnchor, constant: 12),
            appBundleIdenfitierTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            jsonPayloadLabel.topAnchor.constraint(equalTo: appBundleIdenfitierTextField.bottomAnchor, constant: 24),
            jsonPayloadLabel.leadingAnchor.constraint(equalTo: devicesListView.trailingAnchor, constant: 12),
            jsonPayloadLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            jsonPayloadTextField.topAnchor.constraint(equalTo: jsonPayloadLabel.bottomAnchor, constant: 10),
            jsonPayloadTextField.leadingAnchor.constraint(equalTo: devicesListView.trailingAnchor, constant: 12),
            jsonPayloadTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            jsonPayloadTextField.bottomAnchor.constraint(equalTo: sendButton.topAnchor, constant: -12),
            
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            sendButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    func configure(viewModels: [DeviceViewModel]) {
        devicesListViewState.devices = viewModels
    }
    
    func configure(deviceID: String?) {
        devicesListViewState.selectedDeviceID = deviceID
    }
    
    @objc private func didTapSendButton(_ sender: NSButton) {
        delegate?.send(bundleIdentifier: appBundleIdenfitierTextField.stringValue, payload: jsonPayloadTextField.stringValue)
    }
    
    private func getPayloadPlaceholder() -> String? {
        """
        {
            "aps": {
                "alert": {
                    "body": "Gerard added something new",
                    "title": "Photos"
                }
            }
        }
        """
    }
}
