//
//  Card.swift
//  SetGame
//
//  Created by Brian Coleman on 2022-06-13.
//

import Foundation

struct Card: Identifiable, Equatable {
    var id: Int
    var symbol: Symbol
    var numberOfSymbol: Int
    var color: Color
    var shading: Shading
    var isSelected = false
    var isMatch: Bool?
    var isHint: Bool = false
    
    enum Symbol: CaseIterable {
        case diamond
        case rectangle
        case oval
    }
    
    enum Shading: CaseIterable {
        case solid
        case striped
        case open
    }
    
    enum Color: CaseIterable {
        case red
        case green
        case purple
    }
}
