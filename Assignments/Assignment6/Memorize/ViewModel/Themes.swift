//
//  Themes.swift
//  Memorize
//
//  Created by Brian Coleman on 2022-06-30.
//

import SwiftUI
import Combine

class Themes: ObservableObject {
    @Published private(set) var savedThemes: [Theme]
    static let saveKey = "SavedThemesForEmojiMemoryGame"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
            if let decoded = try? JSONDecoder().decode([Theme].self, from: data) {
                self.savedThemes = decoded
                return
            }
        }
        self.savedThemes = [Theme.vehicles, Theme.halloween, Theme.flags, Theme.animals, Theme.food, Theme.faces, Theme.nature]
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(savedThemes) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
    
    func addTheme(_ theme: Theme) {
        if let index = savedThemes.firstIndex(matching: theme) {
            savedThemes[index] = theme
        } else {
            savedThemes.append(theme)
        }
        save()
    }
    
    func removeTheme(_ theme: Theme) {
        if let index = savedThemes.firstIndex(matching: theme) {
            savedThemes.remove(at: index)
                 save()
        }
    }
}
