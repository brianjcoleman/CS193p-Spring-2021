//
//  CardView.swift
//  Memorize
//
//  Created by Brian Coleman on 2022-06-30.
//

import SwiftUI

struct CardView: View {
    var card: MemoryGame<String>.Card
    var themeColor: Color
    @ObservedObject var viewModel: EmojiMemoryGame
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0 - 90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90))
                            .onAppear() {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90))
                    }
                }
                .padding(5)
                .opacity(0.4)
                    
                Text(card.content)
                    .padding(DrawingConstants.circlePadding)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: UUID())
                    .font(.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
        static let circlePadding: CGFloat = 5
    }
}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView(card: <#MemoryGame<String>.Card#>, themeColor: <#Color#>, viewModel: <#EmojiMemoryGame#>)
//    }
//}
