//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Brian Coleman on 2022-03-13.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
