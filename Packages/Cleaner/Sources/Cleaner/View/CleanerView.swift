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
    
    private lazy var cleanAllDevicesButton: NSButton = {
        let button = NSButton(title: "Clean all", target: self, action: #selector(cleanAllDevicesTapped))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cleanSelectedDevicesButton: NSButton = {
        let button = NSButton(title: "Clean selected", target: self, action: #selector(cleanSelectedDevicesTapped))
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var iosSimulatorCachesLabel: NSTextField = {
        let textField = NSTextField(labelWithString: "iOS Simulator Caches")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var iosSimulatorCachesSizeLabel: NSTextField = {
        let textField = NSTextField(labelWithString: "")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var iosSimulatorCachesCleanButton: NSButton = {
        let button = NSButton(title: "Clean", target: self, action: #selector(iosSimulatorCachesCleanButtonTapped))
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
        addSubview(derivedDataCleanLabel)
        addSubview(derivedDataSizeLabel)
        addSubview(derivedDataCleanButton)
        addSubview(devicesListView)
        addSubview(cleanAllDevicesButton)
        addSubview(cleanSelectedDevicesButton)
        addSubview(iosSimulatorCachesLabel)
        addSubview(iosSimulatorCachesSizeLabel)
        addSubview(iosSimulatorCachesCleanButton)
        
        NSLayoutConstraint.activate([
            derivedDataCleanLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            derivedDataCleanLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            
            derivedDataSizeLabel.topAnchor.constraint(equalTo: derivedDataCleanLabel.bottomAnchor, constant: 12),
            derivedDataSizeLabel.leadingAnchor.constraint(equalTo: derivedDataCleanLabel.leadingAnchor),
            
            derivedDataCleanButton.centerYAnchor.constraint(equalTo: derivedDataSizeLabel.centerYAnchor),
            derivedDataCleanButton.leadingAnchor.constraint(equalTo: derivedDataSizeLabel.trailingAnchor, constant: 12),
            
            devicesListView.topAnchor.constraint(equalTo: derivedDataSizeLabel.bottomAnchor, constant: 36),
            devicesListView.leadingAnchor.constraint(equalTo: derivedDataCleanLabel.leadingAnchor),
            devicesListView.widthAnchor.constraint(equalToConstant: 280),
            devicesListView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12),
            
            cleanAllDevicesButton.topAnchor.constraint(equalTo: devicesListView.bottomAnchor, constant: 12),
            cleanAllDevicesButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            
            cleanSelectedDevicesButton.topAnchor.constraint(equalTo: devicesListView.bottomAnchor, constant: 12),
            cleanSelectedDevicesButton.leadingAnchor.constraint(equalTo: cleanAllDevicesButton.trailingAnchor, constant: 12),
            
            iosSimulatorCachesLabel.topAnchor.constraint(equalTo: cleanAllDevicesButton.bottomAnchor, constant: 36),
            iosSimulatorCachesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            
            iosSimulatorCachesSizeLabel.topAnchor.constraint(equalTo: iosSimulatorCachesLabel.bottomAnchor, constant: 12),
            iosSimulatorCachesSizeLabel.leadingAnchor.constraint(equalTo: iosSimulatorCachesLabel.leadingAnchor),
            
            iosSimulatorCachesCleanButton.centerYAnchor.constraint(equalTo: iosSimulatorCachesSizeLabel.centerYAnchor),
            iosSimulatorCachesCleanButton.leadingAnchor.constraint(equalTo: iosSimulatorCachesSizeLabel.trailingAnchor, constant: 12)
        ])
    }
    
    @objc private func derivedDataCleanButtonTapped() {
        delegate?.cleanDeviredData()
    }
    
    @objc private func cleanAllDevicesTapped() {
        delegate?.cleanSupportedDevices(all: true)
    }
    
    @objc private func cleanSelectedDevicesTapped() {
        delegate?.cleanSupportedDevices(all: false)
    }
    
    @objc private func iosSimulatorCachesCleanButtonTapped() {
        delegate?.cleanIOSSimulatorCaches()
    }
    
    func configure(derivedDataSize: String) {
        derivedDataSizeLabel.stringValue = derivedDataSize
    }
    
    func configure(iosSimulatorCachesSize: String) {
        iosSimulatorCachesSizeLabel.stringValue = iosSimulatorCachesSize
    }
    
    func configure(supportedDevices: [DeviceViewModel]) {
        devicesListViewState.rows = supportedDevices
        let numberOfSelectedDevices = supportedDevices.filter { $0.isSelected }.count
        if numberOfSelectedDevices > 0 {
            cleanSelectedDevicesButton.title = "Clean selected (\(numberOfSelectedDevices))"
            cleanSelectedDevicesButton.isEnabled = true
        } else {
            cleanSelectedDevicesButton.title = "Clean selected"
            cleanSelectedDevicesButton.isEnabled = false
        }
    }
}
