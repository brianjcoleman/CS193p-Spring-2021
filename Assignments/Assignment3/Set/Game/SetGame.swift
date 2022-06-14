//
//  SetGame.swift
//  Set
//
//  Created by Brian Coleman on 2022-06-13.
//

import Foundation

struct SetGame {
    static private let defaultNumberOfCardsToShow = 12

    private(set) var cards: [Card]
    private(set) var numberOfCardsToShow = defaultNumberOfCardsToShow
    private var selectedIndices: [Int]

    init() {
        selectedIndices = [Int]()
        cards = [Card]()
    }

    mutating func newGame() {
        selectedIndices.removeAll()
        cards.removeAll()
        numberOfCardsToShow = SetGame.defaultNumberOfCardsToShow

        for shape in CardShape.allCases {
            for color in CardColor.allCases {
                for number in 1...3 {
                    for shading in CardShading.allCases {
                        let card = Card(
                            shape: shape,
                            number: number,
                            color: color,
                            shading: shading
                        )

                        self.cards.append(card)
                    }
                }
            }
        }

        cards.shuffle()
    }

    mutating func chose(card: Card) {
        if let index = cards.firstIndex(where: { $0 == card }), cards[index].isMatched != true {
            if selectedIndices.count > 2 {
                deselectAllCards()
                reduceNumberOfVisibleCards()
            }

            cards[index].isSelected = !cards[index].isSelected
            if cards[index].isSelected {
                selectedIndices.append(index)

                if areThreeCardsSelected {
                    if areSelectedCardsASet {
                        markSelectedCardsAsMatched()
                    } else {
                        markSelectedCardsAsNotMatched()
                    }
                }
            } else {
                if let indexToRemove = selectedIndices.firstIndex(of: index) {
                    selectedIndices.remove(at: indexToRemove)
                }
            }
        } else {
            deselectAllCards()
        }
    }

    private var areThreeCardsSelected: Bool {
        return self.selectedIndices.count == 3
    }

    mutating func dealMore() {
        if areThreeCardsSelected, areSelectedCardsASet {
            markSelectedCardsAsMatched()
            reduceNumberOfVisibleCards()
        } else {
            if numberOfCardsToShow <= 81 - 3 {
                self.numberOfCardsToShow += 3
            }
        }
        deselectAllCards()
    }

    mutating private func reduceNumberOfVisibleCards() {
        if self.numberOfCardsToShow > SetGame.defaultNumberOfCardsToShow {
            self.numberOfCardsToShow -= 3
        }
    }

    private func areCardsASet(_ first: Card, _ second: Card, _ third: Card) -> Bool {
        let shapes: Set<CardShape> = [first.shape, second.shape, third.shape]
        let numbers: Set<Int> = [first.number, second.number, third.number]
        let colors: Set<CardColor> = [first.color, second.color, third.color]
        let shadings: Set<CardShading> = [first.shading, second.shading, third.shading]

        return shapes.count != 2 && numbers.count != 2 && colors.count != 2 && shadings.count != 2
    }

    private var areSelectedCardsASet: Bool {
        let first = cards[selectedIndices[0]]
        let second = cards[selectedIndices[1]]
        let third = cards[selectedIndices[2]]

        return areCardsASet(first, second, third)
    }

    mutating private func markSelectedCardsAsMatched() {
        if self.selectedIndices.count != 3 {
            return
        }

        for i in selectedIndices {
            cards[i].isMatched = true
        }
    }

    mutating private func markSelectedCardsAsNotMatched() {
        if self.selectedIndices.count != 3 {
            return
        }

        for i in selectedIndices {
            cards[i].isMatched = false
        }
    }

    mutating private func deselectAllCards() {
        for i in selectedIndices {
            cards[i].isSelected = false
            cards[i].isMatched = cards[i].isMatched == true ? true : nil
            cards[i].isHidden = cards[i].isMatched == true ? true : false
        }

        selectedIndices.removeAll()
    }

    mutating func showHint() -> Bool {
        let visibleCards = Array(self.cards.filter { !$0.isHidden })
        let numberOfVisibleCards = min(visibleCards.count, numberOfCardsToShow)

        for i in 0..<numberOfVisibleCards {
            for j in 1..<numberOfVisibleCards {
                for k in 2..<numberOfVisibleCards {
                    if i != j, j != k, i != k, areCardsASet(visibleCards[i], visibleCards[j], visibleCards[k]) {
                        if let index = self.cards.firstIndex(where: { $0 == visibleCards[i] }) {
                            cards[index].isHint = true
                        }
                        if let index = self.cards.firstIndex(where: { $0 == visibleCards[j] }) {
                            cards[index].isHint = true
                        }
                        if let index = self.cards.firstIndex(where: { $0 == visibleCards[k] }) {
                            cards[index].isHint = true
                        }

                        return true
                    }
                }
            }
        }

        return false
    }
}
