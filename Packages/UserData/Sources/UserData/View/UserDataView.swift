//
//  UserDataView.swift
//  
//
//  Created by Гавриил Михайлов on 05.06.2022.
//

import AppKit

final class UserDataView: NSView {
    
    private let themesListViewState = ListViewState(title: "User Themes", selectedRowID: nil, rows: [])
    private let snippetsListViewState = ListViewState(title: "User Snippets", selectedRowID: nil, rows: [])
    
    private weak var delegate: ViewControllerDelegate?
    
    private lazy var userThemesListView: ListView = {
        let listView = ListView(viewState: themesListViewState, delegate: delegate)
        listView.translatesAutoresizingMaskIntoConstraints = false
        return listView
    }()
    
    private lazy var userSnippetsListView: ListView = {
        let listView = ListView(viewState: snippetsListViewState, delegate: delegate)
        listView.translatesAutoresizingMaskIntoConstraints = false
        return listView
    }()
    
    private lazy var exportLabel: NSTextField = {
        let textField = NSTextField(labelWithString: "Export")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var exportArchiveRadioButton: NSButton = {
        let button = NSButton(radioButtonWithTitle: "Archive", target: self, action: #selector(exportArchiveRadioButtonTapped))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.state = .on
        return button
    }()
    
    private lazy var exportCloudRadioButton: NSButton = {
        let button = NSButton(radioButtonWithTitle: "Cloud", target: self, action: #selector(exportCloudRadioButtonTapped))
        button.state = .off
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var exportButton: NSButton = {
        let button = NSButton(title: "Export", target: self, action: #selector(exportButtonTapped))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var importLabel: NSTextField = {
        let textField = NSTextField(labelWithString: "Import")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var importFilesRadioButton: NSButton = {
        let button = NSButton(radioButtonWithTitle: "Files", target: self, action: #selector(importFilesRadioButtonTapped))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.state = .on
        return button
    }()
    
    private lazy var importCloudRadioButton: NSButton = {
        let button = NSButton(radioButtonWithTitle: "Cloud", target: self, action: #selector(importCloudRadioButtonTapped))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.state = .off
        return button
    }()
    
    private lazy var importButton: NSButton = {
        let button = NSButton(title: "Import", target: self, action: #selector(importButtonTapped))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var lastUpdateDateLabel: NSTextField = {
        let textField = NSTextField(labelWithString: "")
        textField.translatesAutoresizingMaskIntoConstraints = false
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
        addSubview(userThemesListView)
        addSubview(userSnippetsListView)
        addSubview(exportLabel)
        addSubview(exportArchiveRadioButton)
        addSubview(exportCloudRadioButton)
        addSubview(exportButton)
        addSubview(importLabel)
        addSubview(importFilesRadioButton)
        addSubview(importCloudRadioButton)
        addSubview(importButton)
        addSubview(lastUpdateDateLabel)
        
        NSLayoutConstraint.activate([
            userThemesListView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            userThemesListView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            userThemesListView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -6),
            userThemesListView.widthAnchor.constraint(equalToConstant: 250),
            
            userSnippetsListView.topAnchor.constraint(equalTo: centerYAnchor, constant: 6),
            userSnippetsListView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            userSnippetsListView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            userSnippetsListView.widthAnchor.constraint(equalToConstant: 250),
            
            exportLabel.bottomAnchor.constraint(equalTo: exportArchiveRadioButton.topAnchor, constant: -12),
            exportLabel.leadingAnchor.constraint(equalTo: exportArchiveRadioButton.leadingAnchor),

            exportArchiveRadioButton.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -12),
            exportArchiveRadioButton.leadingAnchor.constraint(equalTo: userThemesListView.trailingAnchor, constant: 24),
            
            exportCloudRadioButton.bottomAnchor.constraint(equalTo: exportArchiveRadioButton.bottomAnchor),
            exportCloudRadioButton.leadingAnchor.constraint(equalTo: exportArchiveRadioButton.trailingAnchor, constant: 12),
            
            exportButton.centerYAnchor.constraint(equalTo: exportArchiveRadioButton.centerYAnchor),
            exportButton.leadingAnchor.constraint(equalTo: exportCloudRadioButton.trailingAnchor, constant: 12),
            
            importLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 12),
            importLabel.leadingAnchor.constraint(equalTo: userThemesListView.trailingAnchor, constant: 24),
            
            importFilesRadioButton.topAnchor.constraint(equalTo: importLabel.bottomAnchor, constant: 12),
            importFilesRadioButton.leadingAnchor.constraint(equalTo: importLabel.leadingAnchor),
            
            importCloudRadioButton.topAnchor.constraint(equalTo: importFilesRadioButton.topAnchor),
            importCloudRadioButton.leadingAnchor.constraint(equalTo: importFilesRadioButton.trailingAnchor, constant: 12),
            
            importButton.centerYAnchor.constraint(equalTo: importCloudRadioButton.centerYAnchor),
            importButton.leadingAnchor.constraint(equalTo: importCloudRadioButton.trailingAnchor, constant: 12),
            
            lastUpdateDateLabel.leadingAnchor.constraint(equalTo: userSnippetsListView.trailingAnchor, constant: 24),
            lastUpdateDateLabel.bottomAnchor.constraint(equalTo: userSnippetsListView.bottomAnchor)
        ])
    }
    
    @objc private func exportArchiveRadioButtonTapped() {
        exportCloudRadioButton.state = .off
    }
    
    @objc private func exportCloudRadioButtonTapped() {
        exportArchiveRadioButton.state = .off
    }
    
    @objc private func exportButtonTapped() {
        if exportArchiveRadioButton.state == .on {
            delegate?.exportArchive()
        }
        if exportCloudRadioButton.state == .on {
            delegate?.exportCloud()
        }
    }
    
    @objc private func importFilesRadioButtonTapped() {
        importCloudRadioButton.state = .off
    }
    
    @objc private func importCloudRadioButtonTapped() {
        importFilesRadioButton.state = .off
    }
    
    @objc private func importButtonTapped() {
        if importFilesRadioButton.state == .on {
            delegate?.importFiles()
        }
        if importCloudRadioButton.state == .on {
            delegate?.importCloud()
        }
    }
    
    func configure(userThemes: [ListViewRowViewModel]) {
        themesListViewState.rows = userThemes
    }
    
    func configure(userSnippets: [ListViewRowViewModel]) {
        snippetsListViewState.rows = userSnippets
    }
    
    func configure(lastUpdateDate: String) {
        lastUpdateDateLabel.stringValue = lastUpdateDate
    }
}
