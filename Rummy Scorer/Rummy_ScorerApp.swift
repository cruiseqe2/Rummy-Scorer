//
//  Rummy_ScorerApp.swift
//  Rummy Scorer
//
//  Created by Mark Oelbaum on 08/02/2026.
//

import SwiftUI

@main
struct Rummy_ScorerApp: App {
    
    @State private var model = Model()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(model)
        }
    }
}
