//
//  SetGameVM.swift
//  Set
//
//  Created by Brian Coleman on 2022-06-13.
//

import Foundation

class SetGameVM: ObservableObject {
    @Published var model: SetGame

    init() {
        self.model = SetGame()
    }

    var cards: [Card] {
        return model.cards
    }

    var cardsToShow: [Card] {
        Array(self.cards.filter { !$0.isHidden }.prefix(self.model.numberOfCardsToShow))
    }

    func newGame() {
        model.newGame()
    }

    func chose(card: Card) {
        model.chose(card: card)
    }

    func dealMore() {
        model.dealMore()
    }

    func showHint() -> Bool {
        model.showHint()
    }
}
