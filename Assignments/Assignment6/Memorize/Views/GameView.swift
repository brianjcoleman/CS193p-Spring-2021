//
//  ContentView.swift
//  Memorize
//
//  Created by Brian Coleman on 2022-03-13.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    @Namespace private var dealingNamespace
    
    var themeColor: Color {
        return viewModel.theme.color
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.theme.name).font(.largeTitle)
                Spacer()
                Text("Score: \(viewModel.score)").font(.largeTitle)
            }
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(viewModel.cards) { card in
                        if card.isMatched && !card.isFaceUp {
                            Color.clear
                        } else {
                            CardView(card: card, themeColor: themeColor, viewModel: viewModel)
                                .aspectRatio(2/3, contentMode: .fit)
                                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                                .padding(4)
                                .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))
                                .zIndex((zIndex(of: card)))
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.choose(card)
                                    }
                                }
                        }
                    }
                }
            }
            .foregroundColor(themeColor)
            .padding(.horizontal)
            
            Button {
                viewModel.newGame()
            } label: {
                Text("New Game").font(.largeTitle)
            }
        }
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(viewModel.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame(theme: Theme.vehicles)
        GameView(viewModel: game)
            .preferredColorScheme(.dark)
        GameView(viewModel: game)
            .preferredColorScheme(.light)
    }
}
