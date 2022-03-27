//
//  Themes.swift
//  Memorize
//
//  Created by Brian Coleman on 2022-03-27.
//

import Foundation
import SwiftUI

struct Theme {
    var name: String
    var emojis: [String]
    var numberOfPairsOfCards: Int
    var color: Color
    var useGradient: Bool
    
    init(name: String, emojis: [String], numberOfPairsOfCards: Int, color: Color) {
        self.name = name
        self.emojis = emojis
        self.numberOfPairsOfCards = numberOfPairsOfCards > emojis.count ? emojis.count : numberOfPairsOfCards
        self.color = color
        self.useGradient = false
    }
    
    init(name: String, emojis: [String], color: Color, useGradient: Bool = false) {
        self.name = name
        self.emojis = emojis
        self.numberOfPairsOfCards = emojis.count
        self.color = color
        self.useGradient = useGradient
    }
}
