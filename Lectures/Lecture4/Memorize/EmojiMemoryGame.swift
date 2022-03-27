//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Brian Coleman on 2022-03-19.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    init() {
        theme = EmojiMemoryGame.themes.randomElement()!
        theme.emojis.shuffle()
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    static var themes: Array<Theme> = [
        Theme(name: "Vehicles", emojis: ["🚗", "🛴", "✈️", "🛵", "⛵️", "🚎", "🚐", "🚛", "🛻", "🏎", "🚂", "🚊", "🚀", "🚁", "🚢", "🛶", "🛥", "🚞", "🚟", "🚃"],
              numberOfPairsOfCards: 5,
              color: .red),
        Theme(
            name: "Halloween",
            emojis: ["👻","🎃","🕷","🧟‍♂️","🧛🏼‍♀️","☠️","👽","🦹‍♀️","🦇","🌘","⚰️","🔮"],
            numberOfPairsOfCards: Int.random(in: 5..<8),
            color: .orange),
        Theme(
            name: "Flags",
            emojis: ["🇸🇬","🇯🇵","🏴‍☠️","🏳️‍🌈","🇬🇧","🇹🇼","🇺🇸","🇦🇶","🇰🇵","🇭🇰","🇲🇨","🇼🇸"],
            numberOfPairsOfCards: 8,
            color: .blue),
        Theme(name: "Barn Animals",
              emojis: ["🐔", "🐥", "🐮", "🐷", "🐭", "🐑", "🐖", "🐓"],
              numberOfPairsOfCards: 6,
              color: .brown),
        Theme(name: "Food",
              emojis: ["🌭", "🌶", "🍔", "🍟", "🍏", "🍇"],
              numberOfPairsOfCards: 6,
              color: .cyan),
        Theme(name: "Faces",
              emojis: ["😀", "😃", "😂", "🥲", "😎", "🧐"],
              numberOfPairsOfCards: 6,
              color: .yellow),
        Theme(name: "Nature",
              emojis: ["🌳", "🌲", "🌵", "🌴", "⛰", "🗻"],
              color: .green,
             useGradient: true)
    ]
    
    static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairsOfCards) { pairIndex in
            theme.emojis[pairIndex]
        }
    }
       
    @Published private(set) var model: MemoryGame<String>
    
    private var theme: Theme
    
    var themeName: String {
        theme.name
    }
    
    var themeColor: Color {
        theme.color
    }
    
    var useGradient: Bool {
        theme.useGradient
    }
    
    var score: Int {
        model.score
    }
                           
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func newGame() {
        theme = EmojiMemoryGame.themes.randomElement()!
        theme.emojis.shuffle()
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
}
