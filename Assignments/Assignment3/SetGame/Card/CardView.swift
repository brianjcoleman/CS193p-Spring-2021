//
//  CardView.swift
//  SetGame
//
//  Created by Brian Coleman on 2022-06-13.
//

import SwiftUI

struct CardView: View {
    let card: Card
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lindWidth)
                VStack {
                    ForEach(0..<card.numberOfSymbol, id:\.self) { _ in
                        symbol
                            .frame(width: geometry.size.width/2, height: geometry.size.height/6)
                    }
                }
                .foregroundColor(cardColor)
                if card.isSelected {
                    shape.foregroundColor(.gray).opacity(0.5)
                }
                if let isMatch = card.isMatch {
                    shape.foregroundColor(isMatch ? .green : .red).opacity(0.6)
                }
                if card.isHint {
                    shape.foregroundColor(.yellow.opacity(0.6))
                }
            }
        })
    }
    
    @ViewBuilder
    private var symbol: some View {
        switch card.symbol {
        case .diamond:
            switch card.shading {
            case .solid:
                Diamond()
            case .striped:
                Diamond().opacity(0.5)
            case .open:
                Diamond().stroke()
            }
        case .oval:
            switch card.shading {
            case .solid:
                Capsule()
            case .striped:
                Capsule().opacity(0.5)
            case .open:
                Capsule().stroke()
            }
        case .rectangle:
            let rectangle = Rectangle()
            switch card.shading {
            case .solid:
                rectangle
            case .striped:
                rectangle.opacity(0.5)
            case .open:
                rectangle.stroke()
            }
        }
    }
    
    private var cardColor: Color {
        switch card.color {
        case .red:
            return .red
        case .green:
            return .green
        case .purple:
            return .purple
        }
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lindWidth: CGFloat = 3
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let card = Card(
            id: 1,
            symbol: Card.Symbol.oval,
            numberOfSymbol: 3,
            color: Card.Color.purple,
            shading: Card.Shading.solid
        )
        CardView(card: card)
            .frame(width: 200, height: 200)
    }
}
