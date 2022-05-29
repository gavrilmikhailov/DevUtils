//
//  ThemesListViewState.swift
//  
//
//  Created by Гавриил Михайлов on 29.05.2022.
//

import Combine

final class ThemesListViewState: ObservableObject {
    @Published var themes: [ThemeViewModel] = []
    @Published var selectedThemeID: String? = nil
}
