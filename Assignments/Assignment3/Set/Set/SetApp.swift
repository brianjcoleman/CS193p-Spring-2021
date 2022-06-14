//
//  SetApp.swift
//  Set
//
//  Created by Brian Coleman on 2022-06-13.
//

import SwiftUI

@main
struct SetApp: App {
    var body: some Scene {
        WindowGroup {
            SetGameView(viewModel: SetGameVM())
        }
    }
}
