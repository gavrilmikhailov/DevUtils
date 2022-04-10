//
//  Interactor.swift
//  
//
//  Created by Гавриил Михайлов on 26.03.2022.
//

import Foundation

final class Interactor {
    
    private let presenter: Presenter
    private let queue = DispatchQueue(label: "string queue")

    init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func convertStringToPrettifiedJSON(str: String) {
        queue.async { [weak self] in
            guard let self = self else { return }
            let converted: String = self.prettifyStringJSON(str: str, indentation: .spaces(2))
            self.presenter.presentConvertStringToPrettifiedJSON(result: converted)
        }
    }
    
    private func prettifyStringJSON(str: String, indentation: Indentation) -> String {
        let indent: String
        switch indentation {
        case .spaces(let spacesCount):
            indent = String(repeating: " ", count: spacesCount)
        case .tabs:
            indent = "\t"
        }

        var result = ""
        var level = 0
        var isProcessingString = false
        for char in str {
            if isProcessingString {
                if char == "\"" {
                    isProcessingString = false
                }
                result.append(char)
                continue
            }
            switch char {
            case "{":
                level += 1
                result.append("\(char)\n\(String(repeating: indent, count: level))")
            case "}":
                level -= 1
                result.append("\n\(String(repeating: indent, count: level))\(char)")
            case "\"":
                isProcessingString = true
                result.append(char)
            case ":":
                result.append("\(char) ")
            case ",":
                result.append("\(char)\n\(String(repeating: indent, count: level))")
            case "\n", " ":
                break
            default:
                result.append(char)
            }
        }
        return result
    }
}
