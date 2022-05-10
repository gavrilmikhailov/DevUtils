//
//  ViewController.swift
//  
//
//  Created by Гавриил Михайлов on 27.03.2022.
//

import SwiftUI

final class ViewController: NSHostingController<SnippetsView> {
    
    init() {
        super.init(rootView: SnippetsView())
        title = "Snippets Manager"
        // Location /Users/gavriilmihajlov/Library/Developer/Xcode/UserData/CodeSnippets
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
