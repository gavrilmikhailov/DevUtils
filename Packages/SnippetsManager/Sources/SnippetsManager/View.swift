//
//  View.swift
//  
//
//  Created by Гавриил Михайлов on 27.03.2022.
//

import SwiftUI

struct SnippetsManagerView: View {
    
    @State var selectedPath: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Button {
                let openPanel = NSOpenPanel()
                openPanel.canChooseDirectories = true
                openPanel.allowsMultipleSelection = true
                if openPanel.runModal() == .OK {
                    let allPaths: String = openPanel.urls.reduce("") { partialResult, result in
                        return partialResult + result.path + "\n"
                    }
                    let allPaths2: String = openPanel.urls.reduce("") { $0 + $1.path + "\n" }
                    selectedPath = allPaths2
                }
            } label: {
                Text("Select file")
            }
            Text(selectedPath)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
