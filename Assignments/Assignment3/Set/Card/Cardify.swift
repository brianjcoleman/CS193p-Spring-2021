//
//  Cardify.swift
//  Set
//
//  Created by Brian Coleman on 2022-06-13.
//

import SwiftUI

struct Cardify: ViewModifier {
    let isSelected: Bool
    let isMatched: Bool?
    let isHint: Bool

    let cornerRadius = CGFloat(5)
    let lineWidth = CGFloat(2)
    let backgroundColor = Color.gray
    let selectedBackGroundColor = Color.blue
    let matchedBackgroundColor = Color.green
    let notMatchedBackgroundColor = Color.red
    let hintBackgroundColor = Color.yellow
    let cardOpacity = 0.2
    
    func body(content: Content) -> some View {
        var cardColor = backgroundColor

        if isHint {
            cardColor = hintBackgroundColor
        }

        if isSelected {
            cardColor = selectedBackGroundColor
        }

        if let isMatched = isMatched {
            cardColor = isMatched ? matchedBackgroundColor : notMatchedBackgroundColor
        }

        return ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(Color.white)
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(cardColor)
                .opacity(cardOpacity)
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(cardColor, lineWidth: lineWidth)
            content
        }
        .animation(.easeOut, value: UUID())
    }
}

extension View {
    func cardify(
        isSelected: Bool,
        isMatched: Bool?,
        isHint: Bool) -> some View {
            self.modifier(
                Cardify(
                    isSelected: isSelected,
                    isMatched: isMatched,
                    isHint: isHint)
            )
    }
}
