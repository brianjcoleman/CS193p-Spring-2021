//
//  Themes.swift
//  Memorize
//
//  Created by Brian Coleman on 2022-03-27.
//

import Foundation
import SwiftUI

struct Theme: Codable, Identifiable {
    var id = UUID()
    var name: String
    var emojis: [String]
    var numberOfPairsOfCards: Int
    var color: Color
    var useGradient: Bool
    
    var removedEmojis: [String]
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
     
    static let vehicles = Theme(
        name: "Vehicles",
        emojis: ["🚗", "🛴", "✈️", "🛵", "⛵️", "🚎", "🚐", "🚛", "🛻", "🏎", "🚂", "🚊", "🚀", "🚁", "🚢", "🛶", "🛥", "🚞", "🚟", "🚃"],
        numberOfPairsOfCards: 5,
        color: .red,
        useGradient: false,
        removedEmojis: []
    )
    
    static let halloween = Theme(
        name: "Halloween",
        emojis: ["👻","🎃","🕷","🧟‍♂️","🧛🏼‍♀️","☠️","👽","🦹‍♀️","🦇","🌘","⚰️","🔮"],
        numberOfPairsOfCards: Int.random(in: 5..<8),
        color: .orange,
        useGradient: false,
        removedEmojis: []
    )
    
    static let flags = Theme(
        name: "Flags",
        emojis: ["🇸🇬","🇯🇵","🏴‍☠️","🏳️‍🌈","🇬🇧","🇹🇼","🇺🇸","🇦🇶","🇰🇵","🇭🇰","🇲🇨","🇼🇸"],
        numberOfPairsOfCards: 8,
        color: .blue,
        useGradient: false,
        removedEmojis: []
    )
    
    static let animals = Theme(name: "Barn Animals",
       emojis: ["🐔", "🐥", "🐮", "🐷", "🐭", "🐑", "🐖", "🐓"],
       numberOfPairsOfCards: 6,
       color: .brown,
       useGradient: false,
       removedEmojis: []
    )

    static let food = Theme(name: "Food",
        emojis: ["🌭", "🌶", "🍔", "🍟", "🍏", "🍇"],
        numberOfPairsOfCards: 6,
        color: .cyan,
        useGradient: false,
        removedEmojis: []
    )
    
    static let faces = Theme(name: "Faces",
         emojis: ["😀", "😃", "😂", "🥲", "😎", "🧐"],
         numberOfPairsOfCards: 6,
         color: .yellow,
         useGradient: false,
         removedEmojis: []
    )
    
    static let nature = Theme(name: "Nature",
          emojis: ["🌳", "🌲", "🌵", "🌴", "⛰", "🗻"],
         numberOfPairsOfCards: 6,
          color: .green,
          useGradient: true,
          removedEmojis: []
    )
    
    static var themes = [vehicles, halloween, flags, animals, food, faces, nature]
}
