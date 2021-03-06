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
        Theme(name: "Vehicles", emojis: ["๐", "๐ด", "โ๏ธ", "๐ต", "โต๏ธ", "๐", "๐", "๐", "๐ป", "๐", "๐", "๐", "๐", "๐", "๐ข", "๐ถ", "๐ฅ", "๐", "๐", "๐"],
              numberOfPairsOfCards: 5,
              color: .red),
        Theme(
            name: "Halloween",
            emojis: ["๐ป","๐","๐ท","๐งโโ๏ธ","๐ง๐ผโโ๏ธ","โ ๏ธ","๐ฝ","๐ฆนโโ๏ธ","๐ฆ","๐","โฐ๏ธ","๐ฎ"],
            numberOfPairsOfCards: Int.random(in: 5..<8),
            color: .orange),
        Theme(
            name: "Flags",
            emojis: ["๐ธ๐ฌ","๐ฏ๐ต","๐ดโโ ๏ธ","๐ณ๏ธโ๐","๐ฌ๐ง","๐น๐ผ","๐บ๐ธ","๐ฆ๐ถ","๐ฐ๐ต","๐ญ๐ฐ","๐ฒ๐จ","๐ผ๐ธ"],
            numberOfPairsOfCards: 8,
            color: .blue),
        Theme(name: "Barn Animals",
              emojis: ["๐", "๐ฅ", "๐ฎ", "๐ท", "๐ญ", "๐", "๐", "๐"],
              numberOfPairsOfCards: 6,
              color: .brown),
        Theme(name: "Food",
              emojis: ["๐ญ", "๐ถ", "๐", "๐", "๐", "๐"],
              numberOfPairsOfCards: 6,
              color: .cyan),
        Theme(name: "Faces",
              emojis: ["๐", "๐", "๐", "๐ฅฒ", "๐", "๐ง"],
              numberOfPairsOfCards: 6,
              color: .yellow),
        Theme(name: "Nature",
              emojis: ["๐ณ", "๐ฒ", "๐ต", "๐ด", "โฐ", "๐ป"],
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
