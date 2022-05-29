//
//  View.swift
//  
//
//  Created by Гавриил Михайлов on 20.05.2022.
//

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
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
        
        NSLayoutConstraint.activate([
            devicesListView.topAnchor.constraint(equalTo: topAnchor),
            devicesListView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            devicesListView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            devicesListView.widthAnchor.constraint(equalToConstant: 280),
            
            appBundleIdenfitierLabel.topAnchor.constraint(equalTo: topAnchor),
            appBundleIdenfitierLabel.leadingAnchor.constraint(equalTo: devicesListView.trailingAnchor),
            appBundleIdenfitierLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            appBundleIdenfitierTextField.topAnchor.constraint(equalTo: appBundleIdenfitierLabel.bottomAnchor),
            appBundleIdenfitierTextField.leadingAnchor.constraint(equalTo: devicesListView.trailingAnchor),
            appBundleIdenfitierTextField.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func configure(viewModels: [DeviceViewModel]) {
        devicesListViewState.devices = viewModels
    }
    
    func configure(deviceID: String?) {
        devicesListViewState.selectedDeviceID = deviceID
    }
}
