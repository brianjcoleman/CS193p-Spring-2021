//
//  ContentView.swift
//  Memorize
//
//  Created by Brian Coleman on 2022-03-13.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.themeName).font(.largeTitle)
                Spacer()
                Text("Score: \(viewModel.score)").font(.largeTitle)
            }
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card, viewModel: viewModel)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                    }
                }
            }
            .foregroundColor(viewModel.themeColor)
            .padding(.horizontal)
            
            Button {
                viewModel.newGame()
            } label: {
                Text("New Game").font(.largeTitle)
            }
        }
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0)
            } else {
                if viewModel.useGradient {
                    shape.fill(LinearGradient(gradient: Gradient(colors: [viewModel.themeColor, Color.pink]), startPoint: .top, endPoint: .bottom))
                } else {
                    shape.fill(viewModel.themeColor)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        ContentView(viewModel: game)
            .preferredColorScheme(.dark)
        ContentView(viewModel: game)
            .preferredColorScheme(.light)
    }
}
