//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Brian Coleman on 2022-06-21.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    let document = EmojiArtDocument()
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
        }
    }
}
