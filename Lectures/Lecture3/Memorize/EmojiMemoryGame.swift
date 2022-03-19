//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Brian Coleman on 2022-03-19.
//

import SwiftUI

class EmojiMemoryGame {
    static let emojis = ["🚗", "🛴", "✈️", "🛵", "⛵️", "🚎", "🚐", "🚛", "🛻", "🏎", "🚂", "🚊", "🚀", "🚁", "🚢", "🛶", "🛥", "🚞", "🚟", "🚃"]
    
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    private(set) var model: MemoryGame<String> = createMemoryGame()
                           
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
}
