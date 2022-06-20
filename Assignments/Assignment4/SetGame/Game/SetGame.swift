//
//  SetGame.swift
//  SetGame
//
//  Created by Brian Coleman on 2022-06-13.
//

import Foundation
import SwiftUI

struct SetGame {
    private(set) var deck: [Card]
    private(set) var table: [Card]
    private(set) var discardPile: [Card] = []
    
    private struct GameConstants {
        static let numberOfCardOnTable = 12
        static let numberOfMatchCard = 3
        static let numberOfDealCard = 3
    }
        
    private var indexOfchosen: [Int] {
        get { table.indices.filter { table[$0].isSelected } }
    }
        
    private var isMatch: Bool {
        get {
            if indexOfchosen.count == GameConstants.numberOfMatchCard {
                let card1 = table[indexOfchosen[0]]
                let card2 = table[indexOfchosen[1]]
                let card3 = table[indexOfchosen[2]]
                let isSetOfNumberOfShape = (card1.numberOfSymbol == card2.numberOfSymbol && card1.numberOfSymbol == card3.numberOfSymbol) ||
                (card1.numberOfSymbol != card2.numberOfSymbol && card2.numberOfSymbol != card3.numberOfSymbol && card1.numberOfSymbol != card3.numberOfSymbol)
                let isSetOfColor = (card1.color == card2.color && card1.color == card3.color) ||
                (card1.color != card2.color && card2.color != card3.color && card1.color != card3.color)
                let isSetOfSymbol = (card1.symbol == card2.symbol && card1.symbol == card3.symbol) ||
                (card1.symbol != card2.symbol && card2.symbol != card3.symbol && card1.symbol != card3.symbol)
                let isSetOfshading = (card1.shading == card2.shading && card1.shading == card3.shading) ||
                (card1.shading != card2.shading && card2.shading != card3.shading && card1.shading != card3.shading)
                return isSetOfNumberOfShape && isSetOfColor && isSetOfSymbol && isSetOfshading
            } else {
                return false
            }
        }
    }
    
    init() {
        deck = []
        var id = 0
        for symbol in Card.Symbol.allCases {
            for shading in Card.Shading.allCases {
                for color in Card.Color.allCases {
                    for number in 1...3 {
                        deck.append(
                            Card(
                                id: id,
                                symbol: symbol,
                                numberOfSymbol: number,
                                color: color,
                                shading: shading,
                                isFaceUp: false
                            )
                        )
                        id += 1
                    }
                }
            }
        }
        deck.shuffle()

        table = []
        for _ in 0..<GameConstants.numberOfCardOnTable {
            var card = deck.popLast()!
            card.isFaceUp = true
            table.append(card)
        }
    }
    
    mutating func choose(_ card: Card) {
        if indexOfchosen.count == GameConstants.numberOfMatchCard {
            if isMatch {
                discard()
            }
            table.indices.forEach {
                table[$0].isSelected = false
                table[$0].isMatch = nil
                table[$0].isHint = false
            }
        }
        
        if let chosenIndex = table.firstIndex(where: {$0.id == card.id}) {
            table[chosenIndex].isSelected.toggle()
            if indexOfchosen.count == GameConstants.numberOfMatchCard {
                let isMatch = isMatch
                indexOfchosen.forEach({ i in
                    table[i].isMatch = isMatch
                    table[i].isHint = false
                })
            }
        }
    }
    
    private mutating func discard() {
        indexOfchosen.reversed().forEach({ i in
            var card = table.remove(at: i)
            card.isMatch = nil
            card.isSelected = false
            card.isHint = false
            discardPile.append(card)
        })
    }
    
    private mutating func replaceNewCard() {
        indexOfchosen.reversed().forEach({ i in
            var card = table.remove(at: i)
            card.isMatch = nil
            card.isSelected = false
            card.isFaceUp = true
            card.isHint = false
            discardPile.append(card)
        })
    }
    
    mutating func dealThreeMoreCard() {
        if isMatch {
            replaceNewCard()
            return
        }
        for _ in 0..<GameConstants.numberOfDealCard {
            var card = deck.popLast()!
            card.isFaceUp = true
            card.isHint = false
            table.append(card)
        }
    }
    
    private func areCardsASet(_ first: Card, _ second: Card, _ third: Card) -> Bool {
        let card1 = first
        let card2 = second
        let card3 = third
        let isSetOfNumberOfShape = (card1.numberOfSymbol == card2.numberOfSymbol && card1.numberOfSymbol == card3.numberOfSymbol) ||
        (card1.numberOfSymbol != card2.numberOfSymbol && card2.numberOfSymbol != card3.numberOfSymbol && card1.numberOfSymbol != card3.numberOfSymbol)
        let isSetOfColor = (card1.color == card2.color && card1.color == card3.color) ||
        (card1.color != card2.color && card2.color != card3.color && card1.color != card3.color)
        let isSetOfSymbol = (card1.symbol == card2.symbol && card1.symbol == card3.symbol) ||
        (card1.symbol != card2.symbol && card2.symbol != card3.symbol && card1.symbol != card3.symbol)
        let isSetOfshading = (card1.shading == card2.shading && card1.shading == card3.shading) ||
        (card1.shading != card2.shading && card2.shading != card3.shading && card1.shading != card3.shading)
        return isSetOfNumberOfShape && isSetOfColor && isSetOfSymbol && isSetOfshading
    }
       
    mutating func showHint() -> Bool {
        let visibleCards = Array(self.table)
        let numberOfVisibleCards = min(visibleCards.count, GameConstants.numberOfCardOnTable)

        for i in 0..<numberOfVisibleCards {
            for j in 1..<numberOfVisibleCards {
                for k in 2..<numberOfVisibleCards {
                    if i != j, j != k, i != k, areCardsASet(visibleCards[i], visibleCards[j], visibleCards[k]) {
                        if let index = self.table.firstIndex(where: { $0 == visibleCards[i] }) {
                            table[index].isHint = true
                        }
                        if let index = self.table.firstIndex(where: { $0 == visibleCards[j] }) {
                            table[index].isHint = true
                        }
                        if let index = self.table.firstIndex(where: { $0 == visibleCards[k] }) {
                            table[index].isHint = true
                        }

                        return true
                    }
                }
            }
        }

        return false
    }
}
