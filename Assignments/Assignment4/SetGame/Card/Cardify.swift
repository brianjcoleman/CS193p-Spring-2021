//
//  Cardify.swift
//  SetGame
//
//  Created by Brian Coleman on 2022-06-20.
//

import SwiftUI

struct Cardify: Animatable, ViewModifier {
   
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    var rotation: Double // in degrees
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if animatableData < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lindWidth)
            } else {
                shape.fill()
            }
            content
                .opacity(animatableData < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(animatableData), axis: (0, 1, 0))
    }
    
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 20
        static let lindWidth: CGFloat = 3
    }
}


extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
