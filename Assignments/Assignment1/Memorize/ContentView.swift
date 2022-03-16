//
//  ContentView.swift
//  Memorize
//
//  Created by Brian Coleman on 2022-03-13.
//

import SwiftUI

struct ContentView: View {
    let vehicleEmojis = ["🚗", "🛴", "✈️", "🛵", "⛵️", "🚎", "🚐", "🚛", "🛻", "🏎", "🚂", "🚊", "🚀", "🚁", "🚢", "🛶", "🛥", "🚞", "🚟", "🚃"]
    let animalEmojis = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼"]
    let foodEmojis = ["🍔", "🥐", "🍕", "🥗", "🥟", "🍣", "🍪", "🍚", "🍝", "🥙", "🍭", "🍤", "🥞", "🍦", "🍛", "🍗"]
    @State var emojis = ["🚗", "🛴", "✈️", "🛵", "⛵️", "🚎", "🚐", "🚛", "🛻", "🏎", "🚂", "🚊", "🚀", "🚁", "🚢", "🛶", "🛥", "🚞", "🚟", "🚃"]
    
    @State var emojiCount = 15
    @State var gameSpace = CGSize(width: 0, height: 0)
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Memorize!")
                .font(.largeTitle)
            ScrollView {
                let bestWidth = widthThatBestFits(cardCount: emojiCount)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: bestWidth))]) {
                    ForEach(emojis[0..<emojiCount], id: \.self) { emoji in
                        CardView(content: emoji)
                            .aspectRatio(2/3, contentMode: .fit)
                    }
                }
            }
            .foregroundColor(/*@START_MENU_TOKEN@*/.red/*@END_MENU_TOKEN@*/)
            Spacer()
            HStack {
                Spacer()
                vehicleButton
                Spacer()
                animalButton
                Spacer()
                foodButton
                Spacer()
            }
            .font(.largeTitle)
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
    
    var vehicleButton: some View {
        Button {
            emojis = vehicleEmojis.shuffled()
            emojiCount = Int.random(in: 4...emojis.count)
        } label: {
            VStack {
                Image(systemName: "car.fill").font(.largeTitle)
                Text("Vehicles").font(.footnote)
            }
        }
    }
    
    var animalButton: some View {
        Button {
            emojis = animalEmojis.shuffled()
            emojiCount = Int.random(in: 4...emojis.count)
        } label: {
            VStack {
                Image(systemName: "pawprint.fill").font(.largeTitle)
                Text("Animals").font(.footnote)
            }
        }
    }
    
    var foodButton: some View {
        Button {
            emojis = foodEmojis.shuffled()
            emojiCount = Int.random(in: 4...emojis.count)
        } label: {
            VStack {
                Image(systemName: "applelogo").font(.largeTitle)
                Text("Food").font(.footnote)
            }
        }
    }
    
    func widthThatBestFits(cardCount: Int) -> CGFloat {
        switch cardCount {
            case 4:
                return UIScreen.main.bounds.size.width / 4
            case 5...9:
                return 80
            default:
                return 65
        }
    }
}

struct CardView: View {
    var content: String
    @State var isFaceUp: Bool = true
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(content).font(.largeTitle)
            } else {
                shape.fill()
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
        ContentView()
            .preferredColorScheme(.light)
    }
}
