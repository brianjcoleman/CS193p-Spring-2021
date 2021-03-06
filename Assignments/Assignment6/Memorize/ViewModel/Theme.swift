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
        emojis: ["๐", "๐ด", "โ๏ธ", "๐ต", "โต๏ธ", "๐", "๐", "๐", "๐ป", "๐", "๐", "๐", "๐", "๐", "๐ข", "๐ถ", "๐ฅ", "๐", "๐", "๐"],
        numberOfPairsOfCards: 5,
        color: .red,
        useGradient: false,
        removedEmojis: []
    )
    
    static let halloween = Theme(
        name: "Halloween",
        emojis: ["๐ป","๐","๐ท","๐งโโ๏ธ","๐ง๐ผโโ๏ธ","โ ๏ธ","๐ฝ","๐ฆนโโ๏ธ","๐ฆ","๐","โฐ๏ธ","๐ฎ"],
        numberOfPairsOfCards: Int.random(in: 5..<8),
        color: .orange,
        useGradient: false,
        removedEmojis: []
    )
    
    static let flags = Theme(
        name: "Flags",
        emojis: ["๐ธ๐ฌ","๐ฏ๐ต","๐ดโโ ๏ธ","๐ณ๏ธโ๐","๐ฌ๐ง","๐น๐ผ","๐บ๐ธ","๐ฆ๐ถ","๐ฐ๐ต","๐ญ๐ฐ","๐ฒ๐จ","๐ผ๐ธ"],
        numberOfPairsOfCards: 8,
        color: .blue,
        useGradient: false,
        removedEmojis: []
    )
    
    static let animals = Theme(name: "Barn Animals",
       emojis: ["๐", "๐ฅ", "๐ฎ", "๐ท", "๐ญ", "๐", "๐", "๐"],
       numberOfPairsOfCards: 6,
       color: .brown,
       useGradient: false,
       removedEmojis: []
    )

    static let food = Theme(name: "Food",
        emojis: ["๐ญ", "๐ถ", "๐", "๐", "๐", "๐"],
        numberOfPairsOfCards: 6,
        color: .cyan,
        useGradient: false,
        removedEmojis: []
    )
    
    static let faces = Theme(name: "Faces",
         emojis: ["๐", "๐", "๐", "๐ฅฒ", "๐", "๐ง"],
         numberOfPairsOfCards: 6,
         color: .yellow,
         useGradient: false,
         removedEmojis: []
    )
    
    static let nature = Theme(name: "Nature",
          emojis: ["๐ณ", "๐ฒ", "๐ต", "๐ด", "โฐ", "๐ป"],
         numberOfPairsOfCards: 6,
          color: .green,
          useGradient: true,
          removedEmojis: []
    )
    
    static var themes = [vehicles, halloween, flags, animals, food, faces, nature]
}
