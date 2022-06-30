//
//  ThemeListView.swift
//  Memorize
//
//  Created by Brian Coleman on 2022-06-30.
//

import SwiftUI

struct ThemesListView: View {
    @ObservedObject var viewModelThemes: Themes
    @State var showingUpdateThemeView = false
    @State var editMode: EditMode = .inactive
    @State private var selectedTheme: Theme?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModelThemes.savedThemes) { theme in
                    NavigationLink(destination: GameView(viewModel: EmojiMemoryGame(theme: theme))) {
                        HStack {
                            ZStack {
                                Circle()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(theme.color)
                                Image(systemName: "pencil")
                                    .foregroundColor(.white)
                                    .opacity(editMode.isEditing ? 1 : 0)
                                    .onTapGesture {
                                        selectedTheme = theme
                                        showingUpdateThemeView = true
                                    }
                            }.frame(width: 25, height: 25)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(theme.name)
                                    .font(.headline)
                                    .foregroundColor(theme.color)
                                Text(showListOfEmojis(theme: theme))
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.map { viewModelThemes.savedThemes[$0] }.forEach { theme in
                        viewModelThemes.removeTheme(theme)
                    }
                }
            }
            .sheet(isPresented: $showingUpdateThemeView) {
                ThemeEditorView(theme: $selectedTheme) { updatedTheme in
                    viewModelThemes.addTheme(updatedTheme)
                    editMode = .inactive
                }
            }
            
            .navigationBarTitle("Memorize")
            .navigationBarItems(leading: Button(action: { addNewTheme() })
                                        { Image(systemName: "plus").frame(width: 50, height: 50) },
                                trailing: EditButton().frame(width: 50, height: 50)
            )
            .environment(\.editMode, $editMode)
        }
    }
    
    private func showListOfEmojis(theme: Theme) -> String {
        let pairsStr = theme.numberOfPairsOfCards == theme.emojis.count ? "" : "\(theme.numberOfPairsOfCards) of "
        return pairsStr + String(theme.emojis.joined())
    }
    
    private func addNewTheme() {
        selectedTheme = nil
        showingUpdateThemeView = true
    }
}

struct ThemesListView_Previews: PreviewProvider {
    static var previews: some View {
        ThemesListView(viewModelThemes: Themes())
    }
}
