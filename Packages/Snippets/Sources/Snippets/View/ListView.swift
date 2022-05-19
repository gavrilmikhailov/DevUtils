//
//  ListView.swift
//  
//
//  Created by Гавриил Михайлов on 19.05.2022.
//

import AppKit

final class ListView: NSView {
    
    private weak var delegate: ViewControllerDelegate?
    
    private var representableViewModels: [SnippetViewModel] = []
    
    private lazy var tableView: NSTableView = {
        let tableView = NSTableView()
        
        tableView.addTableColumn(NSTableColumn(identifier: .init(rawValue: "name")))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.setContentHuggingPriority(.defaultLow, for: .vertical)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(frame: NSRect, delegate: ViewControllerDelegate?) {
        self.delegate = delegate
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(viewModels: [SnippetViewModel]) {
        representableViewModels = viewModels
        tableView.reloadData()
    }
}

extension ListView: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return representableViewModels.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = CellView(frame: .zero)
        cellView.configure(text: representableViewModels[row].title)
        return cellView
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        delegate?.selectSnippet(at: tableView.selectedRow)
    }
}
