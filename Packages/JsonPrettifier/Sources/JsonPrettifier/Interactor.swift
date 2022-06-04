//
//  Interactor.swift
//  
//
//  Created by Гавриил Михайлов on 26.03.2022.
//

import Foundation
import DevToolsCore
import JavaScriptCore

final class Interactor {
    
    private let presenter: Presenter
    private let queue = DispatchQueue(label: "string queue")
    private let debouncer = Debouncer(queue: DispatchQueue.global())

    init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func getPreviouslyConvertedString() {
        let value = UserDefaults.standard.string(forKey: "PreviouslyConvertedString")
        presenter.presentPreviouslyConvertedString(value: value)
    }
    
    func getPreviousDividerOffset() {
        let value = UserDefaults.standard.double(forKey: "dividerOffset")
        presenter.presentPreviousDividerOffset(value: value)
    }
    
    func convertStringToPrettifiedJSON(str: String) {
        UserDefaults.standard.set(str, forKey: "PreviouslyConvertedString")
        queue.async { [weak self] in
            guard let self = self else { return }
            let converted: String = self.prettifyStringJSON(str: str)
            self.presenter.presentConvertStringToPrettifiedJSON(result: converted)
        }
    }
    
    func setIndentation(mode: Indentation?) {
        if let mode = mode {
            switch mode {
            case .spaces(let spaces):
                UserDefaults.standard.set(spaces, forKey: "IndentationMode")
            case .tabs:
                UserDefaults.standard.set(-1, forKey: "IndentationMode")
            }
            presenter.presentSetIndentation(mode: mode)
        } else {
            let previousMode = UserDefaults.standard.integer(forKey: "IndentationMode")
            if previousMode != 0 {
                presenter.presentSetIndentation(mode: previousMode == -1 ? .tabs : .spaces(previousMode))
            } else {
                setIndentation(mode: .spaces(2))
            }
        }
    }
    
    func setDividerOffset(value: CGFloat) {
        debouncer.run {
            UserDefaults.standard.set(value, forKey: "dividerOffset")
        }
    }
    
    private func prettifyStringJSON(str: String) -> String {
        let indent: String
        switch getIndentation() {
        case .spaces(let spacesCount):
            indent = String(repeating: " ", count: spacesCount)
        case .tabs:
            indent = "\t"
        }
        let jsSource = "var prettifyJson = function(str, indent) { return JSON.stringify(JSON.parse(str), null, indent) }"
        let jsContext = JSContext()
        jsContext?.evaluateScript(jsSource)
        let jsFunc = jsContext?.objectForKeyedSubscript("prettifyJson")
        let jsResult = jsFunc?.call(withArguments: [str, indent])
        return jsResult?.toString() ?? "Error"
    }
    
    private func getIndentation() -> Indentation {
        let modeValue = UserDefaults.standard.integer(forKey: "IndentationMode")
        switch modeValue {
        case -1:
            return .tabs
        case 0:
            return .spaces(2)
        default:
            return .spaces(modeValue)
        }
    }
}
