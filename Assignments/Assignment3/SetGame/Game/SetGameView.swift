//
//  SetGameView.swift
//  SetGame
//
//  Created by Brian Coleman on 2022-06-13.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGameVM
    
    var body: some View {
        VStack {
            HStack {
                ShowHintButton(viewModel: game)
                Spacer()
                Button("New Game") {
                    game.newGame()
                }
            }
            AspectVGrid(items: game.table, aspectRatio: 2/3, content: { card in
                CardView(card: card)
                    .padding(4)
                    .onTapGesture {
                        game.choose(card)
                    }
            })
            HStack {
                Button("Deal 3 More Cards") {
                    game.dealThreeMoreCard()
                }.disabled(game.deck.isEmpty)
            }
        }
        .padding(.horizontal)
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
