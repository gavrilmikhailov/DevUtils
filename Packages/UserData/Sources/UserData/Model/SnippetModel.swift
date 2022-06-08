//
//  SnippetModel.swift
//  
//
//  Created by Гавриил Михайлов on 05.06.2022.
//

import Foundation

struct SnippetModel: FileProtocol {
    let id: String
    let title: String?
    let content: String?
    let url: URL
}
