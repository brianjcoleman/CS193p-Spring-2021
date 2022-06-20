//
//  SetGameView.swift
//  SetGame
//
//  Created by Brian Coleman on 2022-06-13.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGameVM
    
    @Namespace private var dealingNamespace
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                gameBody
                HStack {
                    Spacer()
                    ShowHintButton(viewModel: game)
                    newGame
                    Spacer()
                }
                .padding(.horizontal)
            }
            HStack {
                deckBody
                Spacer()
                dicardPileBody
            }
        }
        .padding()
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.table, aspectRatio: 2/3, content: { card in
            CardView(card: card)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .padding(4)
                .transition(.asymmetric(insertion: .identity, removal: .identity))
                .onTapGesture {
                    withAnimation(.easeInOut(duration: CardConstants.dealDuration)) {
                        game.choose(card)
                    }
                }
        })
    }
    
    var newGame: some View {
        Button("New Game") {
            withAnimation(.easeInOut(duration: CardConstants.dealDuration)) {
                game.newGame()
            }
        }
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.deck) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .opacity, removal: .identity))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        //.foregroundColor(CardConstants.color)
        .onTapGesture {
            withAnimation(.easeInOut(duration: CardConstants.dealDuration)) {
                game.dealThreeMoreCard()
            }
        }
    }
    
    var dicardPileBody: some View {
        ZStack {
            ForEach(game.discardPile) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .opacity))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        //.foregroundColor(CardConstants.color)
    }
    
    private struct CardConstants {
        static let color = Color.black
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.7
        static let totalDealDuration: Double = 5
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

struct ShowHintButton: View {
    @ObservedObject var viewModel: SetGameVM
    @State var isAlertVisible: Bool = false

    var body: some View {
        Button(action: {
            withAnimation {
                self.isAlertVisible = !self.viewModel.showHint()
            }
        }, label: {
            Text("Hint")
        })
        .padding()
        .alert(isPresented: $isAlertVisible) {
            Alert(
                title: Text("No Sets available"),
                message: Text("Do you want to deal more cards?"),
                primaryButton: .default(Text("Yes")) {
                    withAnimation { viewModel.dealThreeMoreCard() }
                },
                secondaryButton: .cancel()
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameVM()
        SetGameView(game: game)
    }
}
