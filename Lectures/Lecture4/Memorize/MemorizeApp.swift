//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Brian Coleman on 2022-03-13.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
