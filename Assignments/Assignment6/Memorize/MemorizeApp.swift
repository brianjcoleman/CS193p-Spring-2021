//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Brian Coleman on 2022-03-13.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let themes = Themes()
    var body: some Scene {
        WindowGroup {
            ThemesListView(viewModelThemes: themes)
        }
    }
}
