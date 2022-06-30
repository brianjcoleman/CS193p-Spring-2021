//
//  ThemeEditorView.swift
//  Memorize
//
//  Created by Brian Coleman on 2022-06-30.
//

import SwiftUI

struct ThemeEditorView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var theme: Theme?
    var updateChanges: (Theme) -> Void
    
    @State private var themeToAdd: Theme
    @State private var emojiToAdd = ""
    private var colors: [UIColor] = [.red, .blue, .green, .purple, .yellow, .magenta, .orange, .cyan, .brown]
    private var validData: Bool {
        !themeToAdd.name.isEmpty && themeToAdd.emojis.count > 1 && themeToAdd.numberOfPairsOfCards > 1
    }
    
    init(theme: Binding<Theme?>, updateChanges: @escaping (Theme) -> Void) {
        self._theme = theme
        self.updateChanges = updateChanges
        self._themeToAdd = State(wrappedValue: theme.wrappedValue ?? Theme(id: UUID(), name: "", emojis: [], numberOfPairsOfCards: 0, color: .red, useGradient: false, removedEmojis: []))
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                Button("Save") {
                    updateChanges(themeToAdd)
                    self.presentationMode.wrappedValue.dismiss()
                }.disabled(!validData)
            }
            .padding([.leading, .trailing, .top], 15)
            
            Form {
                Section(header: Text("Set title")) {
                    TextField("Name theme", text: $themeToAdd.name)
                }
                Section(header: Text("Theme color")) {
                    Grid(colors, id: \.self) { color in
                        ZStack {
                            Circle().fill(Color(color)).frame(width: 35, height: 35)
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.white)
                                .opacity(UIColor(themeToAdd.color) == color ? 1 : 0)
                        }
                        .onTapGesture {
                            themeToAdd.color = Color(color)
                        }
                    }.frame(minHeight: 20, idealHeight: 80, maxHeight: 100)
                }
                Section(header: Text("Add emoji")) {
                    HStack {
                        TextField("Emoji", text: $emojiToAdd)
                        Button("Add") {
                            for character in emojiToAdd {
                                if !themeToAdd.emojis.contains(String(character)) {
                                    themeToAdd.emojis.append(String(character))
                                }
                            }
                            emojiToAdd = ""
                            updateCardsNumber()
                        }.disabled(emojiToAdd.isEmpty)
                    }
                }
                if themeToAdd.emojis.count > 1 {
                    Section(header: Text("Number of cards to play")) {
                        Stepper(value: $themeToAdd.numberOfPairsOfCards, in: 2...themeToAdd.emojis.count) {
                            Text("\(themeToAdd.numberOfPairsOfCards) pairs")
                        }
                    }
                }
                Section(header: Text("Emojis to play"), footer: Text("Tap emoji to exclude")) {
                    Grid(themeToAdd.emojis, id: \.self) { emoji in
                        Text(emoji)
                            .frame(width: 30, height: 30)
                            .onTapGesture {
                                withAnimation {
                                    removeEmoji(emoji)
                                }
                            }
                    }.frame(minHeight: 20, idealHeight: 100, maxHeight: 300)
                }
                if !themeToAdd.removedEmojis.isEmpty {
                    Section(header: Text("Removed emojis"), footer: Text("Tap emoji to include in the game")) {
                        Grid(themeToAdd.removedEmojis, id: \.self) { emoji in
                            Text(emoji)
                                .frame(width: 30, height: 30)
                                .onTapGesture {
                                    withAnimation {
                                        returnEmoji(emoji)
                                    }
                                }
                        }.frame(minHeight: 20, idealHeight: 100, maxHeight: 300)
                    }
                }
            }
        }
    }
    
    private func updateCardsNumber() {
        themeToAdd.numberOfPairsOfCards = themeToAdd.emojis.count
    }
    
    private func removeEmoji(_ emoji: String) {
        if let index = themeToAdd.emojis.firstIndex(of: emoji) {
            themeToAdd.removedEmojis.append(themeToAdd.emojis.remove(at: index))
            updateCardsNumber()
        }
    }
    
    private func returnEmoji(_ emoji: String) {
        if let index = themeToAdd.removedEmojis.firstIndex(of: emoji) {
            themeToAdd.emojis.append(themeToAdd.removedEmojis.remove(at: index))
            updateCardsNumber()
        }
    }
}

struct ThemeEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditorView(theme: Binding.constant(
            Theme(
            name: "Vehicles",
            emojis: ["🚗", "🛴", "✈️", "🛵", "⛵️", "🚎", "🚐", "🚛", "🛻", "🏎", "🚂", "🚊", "🚀", "🚁", "🚢", "🛶", "🛥", "🚞", "🚟", "🚃"],
            numberOfPairsOfCards: 5,
            color: .red,
            useGradient: false,
            removedEmojis: []
            )
        )) { theme in
            print(theme)
        }
    }
}
