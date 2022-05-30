//
//  PreferencesView.swift
//  DeveloperTools
//
//  Created by Гавриил Михайлов on 31.05.2022.
//

import AppKit

final class PreferencesView: NSView {
    
    private enum ViewMetrics {
        static let imageSize = CGSize(width: 72, height: 72)
    }
    
    private weak var delegate: PreferencesViewControllerDelegate?
    
    private lazy var photoImageView: NSImageView = {
        let imageView = NSImageView()
        imageView.imageScaling = .scaleProportionallyDown
        imageView.imageAlignment = .alignCenter
        imageView.wantsLayer = true
        imageView.layer?.cornerRadius = ViewMetrics.imageSize.height / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var nameTextField: NSTextField = {
        let textField = NSTextField(labelWithString: "")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var emailTextField: NSTextField = {
        let textField = NSTextField(labelWithString: "")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var signInButton: NSButton = {
        let button = NSButton(title: "Sign in", target: self, action: #selector(didTapSignIn(_:)))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var signOutButton: NSButton = {
        let button = NSButton(title: "Sign out", target: self, action: #selector(didTapSignOut(_:)))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(frame: NSRect, delegate: PreferencesViewControllerDelegate) {
        self.delegate = delegate
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(photoImageView)
        addSubview(nameTextField)
        addSubview(emailTextField)
        addSubview(signInButton)
        addSubview(signOutButton)
        
        NSLayoutConstraint.activate([
            photoImageView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -4),
            photoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: ViewMetrics.imageSize.height),
            photoImageView.widthAnchor.constraint(equalToConstant: ViewMetrics.imageSize.width),
            
            nameTextField.topAnchor.constraint(equalTo: centerYAnchor, constant: 4),
            nameTextField.centerXAnchor.constraint(equalTo: centerXAnchor),

            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            emailTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            signOutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            signOutButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            signInButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            signInButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func configure(user: UserViewModel?) {
        if let user = user {
            nameTextField.stringValue = user.name ?? ""
            emailTextField.stringValue = user.email ?? ""
            if let photo = user.photo {
                photoImageView.image = NSImage(contentsOf: photo)
            }
        } else {
            nameTextField.stringValue = ""
            emailTextField.stringValue = ""
            photoImageView.image = nil
        }
        signInButton.isHidden = user != nil
        signOutButton.isHidden = user == nil
    }
    
    @objc private func didTapSignIn(_ sender: NSButton) {
        delegate?.signIn()
    }
    
    @objc private func didTapSignOut(_ sender: NSButton) {
        delegate?.signOut()
    }
}
