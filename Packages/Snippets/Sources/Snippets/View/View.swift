//
//  SnippetsView.swift
//  
//
//  Created by Гавриил Михайлов on 27.03.2022.
//

import AppKit

final class SnippetsView: NSView {
    
    private weak var delegate: ViewControllerDelegate?
    
    private lazy var listView: ListView = {
        let view = ListView(frame: .zero, delegate: delegate)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var previewView: PreviewView = {
        let view = PreviewView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        wantsLayer = true
        addSubview(listView)
        addSubview(previewView)
        
        NSLayoutConstraint.activate([
            listView.topAnchor.constraint(equalTo: topAnchor),
            listView.leadingAnchor.constraint(equalTo: leadingAnchor),
            listView.trailingAnchor.constraint(equalTo: centerXAnchor),
            listView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            previewView.topAnchor.constraint(equalTo: topAnchor),
            previewView.leadingAnchor.constraint(equalTo: centerXAnchor),
            previewView.trailingAnchor.constraint(equalTo: trailingAnchor),
            previewView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func configure(snippets: [SnippetViewModel]) {
        listView.configure(viewModels: snippets)
    }
    
    func configure(content: SnippetContentViewModel) {
        previewView.configure(content: content)
    }
}
