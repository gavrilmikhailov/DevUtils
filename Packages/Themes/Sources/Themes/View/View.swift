//
//  View.swift
//  
//
//  Created by Гавриил Михайлов on 29.05.2022.
//

import AppKit

final class ThemesView: NSView {
    
    private let themesListViewState = ThemesListViewState()
    private weak var delegate: ViewControllerDelegate?
    
    private lazy var themesListView: ThemesListView = {
        let view = ThemesListView(viewState: themesListViewState, delegate: delegate)
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var lastUpdateDateLabel: NSTextField = {
        let textField = NSTextField(labelWithString: "")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var exportButton: NSButton = {
        let button = NSButton(title: "Export", target: self, action: #selector(didTapExportButton(_:)))
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
        addSubview(themesListView)
        addSubview(lastUpdateDateLabel)
        addSubview(exportButton)

        NSLayoutConstraint.activate([
            themesListView.topAnchor.constraint(equalTo: topAnchor),
            themesListView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            themesListView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            themesListView.widthAnchor.constraint(equalToConstant: 250),
            
            lastUpdateDateLabel.leadingAnchor.constraint(equalTo: themesListView.trailingAnchor, constant: 12),
            lastUpdateDateLabel.bottomAnchor.constraint(equalTo: exportButton.topAnchor, constant: -12),
            
            exportButton.leadingAnchor.constraint(equalTo: themesListView.trailingAnchor, constant: 12),
            exportButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    @objc private func revealInFinder() {
//        viewDelegate.didTapRevealInFinder()
    }
    
    @objc private func didTapExportButton(_ sender: NSButton) {
        delegate?.uploadFiles()
    }
    
    func reloadData() {
//        collectionView.reloadData()
    }
    
    func configure(viewModels: [ThemeViewModel]) {
        themesListViewState.themes = viewModels
    }
    
    func configure(lastUpdateDate: String) {
        print(lastUpdateDate)
        lastUpdateDateLabel.stringValue = lastUpdateDate
    }
}
