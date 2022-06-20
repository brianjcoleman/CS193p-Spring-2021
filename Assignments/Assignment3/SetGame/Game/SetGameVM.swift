//
//  SetGameVM.swift
//  SetGame
//
//  Created by Brian Coleman on 2022-06-13.
//

import SwiftUI

class SetGameVM: ObservableObject {
    @Published private var model = createSetGame()
    
    private static func createSetGame() -> SetGame {
        SetGame()
    }
        
    var deck: [Card] {
        model.deck
    }
    
    var table: [Card] {
        model.table
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func dealThreeMoreCard() {
        model.dealThreeMoreCard()
    }
    
    func newGame() {
        model = Self.createSetGame()
    }
    
    func showHint() -> Bool {
        model.showHint()
    }
}
