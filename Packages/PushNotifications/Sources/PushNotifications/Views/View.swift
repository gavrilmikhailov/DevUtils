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
        NSLayoutConstraint.activate([
            devicesListView.topAnchor.constraint(equalTo: topAnchor),
            devicesListView.leadingAnchor.constraint(equalTo: leadingAnchor),
            devicesListView.trailingAnchor.constraint(equalTo: trailingAnchor),
            devicesListView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(viewModels: [DeviceViewModel]) {
        devicesListViewState.devices = viewModels
    }
}
