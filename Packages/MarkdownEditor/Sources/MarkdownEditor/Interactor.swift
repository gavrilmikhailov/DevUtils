//
//  Interactor.swift
//  
//
//  Created by Гавриил Михайлов on 10.06.2022.
//

import Foundation
import DevToolsCore
import Down

final class Interactor {
    
    private let presenter: Presenter
    private let debouncer: Debouncer
    
    private var down: Down = Down(markdownString: "")
    
    init(presenter: Presenter,
         debouncer: Debouncer = Debouncer(queue: DispatchQueue.global())) {
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
    
    func format(text: String) {
        do {
            down.markdownString = text
            let attributedString = try down.toAttributedString()
            presenter.presentFormatted(text: attributedString)
        } catch {
            print(error.localizedDescription)
        }
    }
}
