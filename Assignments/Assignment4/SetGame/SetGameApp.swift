//
//  SetGameApp.swift
//  SetGame
//
//  Created by Brian Coleman on 2022-06-13.
//

import SwiftUI

@main
struct SetGameApp: App {
    private let game = SetGameVM()
    
    var body: some Scene {
        WindowGroup {
            SetGameView(game: game)
        }
    }
}
