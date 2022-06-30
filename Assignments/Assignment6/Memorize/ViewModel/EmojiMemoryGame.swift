//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Brian Coleman on 2022-03-19.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    @Published private(set) var model: MemoryGame<String>
    
    var theme: Theme
    
    var cards: [Card] {
        model.cards
    }
    
    var score: Int {
        model.score
    }
    
    init(theme: Theme) {
        self.theme = theme
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        let emojis = theme.emojis.shuffled()
        
        let numberOfPairs = theme.numberOfPairsOfCards
        
        print("json = \(theme.json?.utf8 ?? "nil")")
        
        return MemoryGame<String>(numberOfPairsOfCards: numberOfPairs) { pairIndex in
            emojis[pairIndex]
        }
    }
       
    // MARK: - Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func newGame() {
        theme = Theme.themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
}
