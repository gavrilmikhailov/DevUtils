//
//  CleanerView.swift
//  
//
//  Created by Гавриил Михайлов on 05.06.2022.
//

import AppKit

final class CleanerView: NSView {
    
    private let devicesListViewState = DevicesListViewState()

    private weak var delegate: ViewControllerDelegate?
    
    private lazy var derivedDataCleanLabel: NSTextField = {
        let textField = NSTextField(labelWithString: "XCode Devired Data")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var derivedDataSizeLabel: NSTextField = {
        let textField = NSTextField(labelWithString: "")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var derivedDataCleanButton: NSButton = {
        let button = NSButton(title: "Clean", target: self, action: #selector(derivedDataCleanButtonTapped))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var iosDeviceSupportLabel: NSTextField = {
        let textField = NSTextField(labelWithString: "iOS Device Support")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var devicesListView: DevicesListView = {
        let listView = DevicesListView(viewState: devicesListViewState)
        listView.setContentHuggingPriority(.defaultLow, for: .vertical)
        listView.translatesAutoresizingMaskIntoConstraints = false
        return listView
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
        addSubview(derivedDataCleanLabel)
        addSubview(derivedDataSizeLabel)
        addSubview(derivedDataCleanButton)
        addSubview(devicesListView)
        
        NSLayoutConstraint.activate([
            derivedDataCleanLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            derivedDataCleanLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            
            derivedDataSizeLabel.topAnchor.constraint(equalTo: derivedDataCleanLabel.bottomAnchor, constant: 12),
            derivedDataSizeLabel.leadingAnchor.constraint(equalTo: derivedDataCleanLabel.leadingAnchor),
            
            derivedDataCleanButton.centerYAnchor.constraint(equalTo: derivedDataSizeLabel.centerYAnchor),
            derivedDataCleanButton.leadingAnchor.constraint(equalTo: derivedDataSizeLabel.trailingAnchor, constant: 12),
            
            devicesListView.topAnchor.constraint(equalTo: derivedDataSizeLabel.bottomAnchor, constant: 24),
            devicesListView.leadingAnchor.constraint(equalTo: derivedDataCleanLabel.leadingAnchor),
            devicesListView.widthAnchor.constraint(equalToConstant: 280),
            devicesListView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12)
        ])
    }
    
    @objc private func derivedDataCleanButtonTapped() {
        delegate?.cleanDeviredData()
    }
    
    func configure(derivedDataSize: String) {
        derivedDataSizeLabel.stringValue = derivedDataSize
    }
    
    func configure(supportedDevices: [DeviceViewModel]) {
        devicesListViewState.rows = supportedDevices
    }
}
