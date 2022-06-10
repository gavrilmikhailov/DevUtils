//
//  Interactor.swift
//  
//
//  Created by Гавриил Михайлов on 10.06.2022.
//

import Foundation
import DevToolsCore

final class Interactor {
    
    private let presenter: Presenter
    private let debouncer: Debouncer
    
    init(presenter: Presenter, debouncer: Debouncer = Debouncer(queue: DispatchQueue.global())) {
        self.presenter = presenter
        self.debouncer = debouncer
    }
    
    func getPreviousDividerOffset() {
        let value = UserDefaults.standard.double(forKey: "dividerOffsetMarkdown")
        presenter.presentPreviousDividerOffset(value: value)
    }
    
    func setDividerOffset(value: CGFloat) {
        debouncer.run {
            UserDefaults.standard.set(value, forKey: "dividerOffsetMarkdown")
        }
    }
}
