
//
//  SettingsView.swift
//  Rummy Scorer
//
//  Created by Mark Oelbaum on 24/02/2026.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(Model.self) var model

    var body: some View {
        @Bindable var model = model
        VStack(spacing: 0) {
            
            Text("Elaine's Rummy Scoring")
                .font(.largeTitle).bold()
                .padding(.top, 24)
                .padding(.bottom, 8)
            
            Divider()
            
            Spacer()
            VStack(spacing: 25) {
                Text("Player 1: Elaine")
                Text("Player 2: Mark")
                Text("Using Jokers: Yes")
                Text("Joker Value: 10")
                Text("Play Up To: \(model.playUpTo)")
                
                HStack(spacing: 30) {
                    Text("Who deals first?")
                    HStack(spacing: 30) {
                        RadioButtonsView(
                            model.dealerOptions,
                            selection: $model.firstDealer) { topping in
                                HStack {
                                    Image(systemName: topping.name == model.firstDealer?.name ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(topping.name == model.firstDealer?.name ? .blue : .primary)
                                    Text(topping.name)
                                }
                            }
                    }
                    .disabled(!model.scoreSheet.isEmpty && !model.gameFinished)
                }
                
                HStack(spacing: 50){
                    Button(model.scoreSheet.isEmpty || model.gameFinished ? "Play" : "Continue") {
                        if model.gameFinished {
                            model.scoreSheet.removeAll()
                            model.lineNumber = 1
                            model.p0EntryMade = false
                            model.p1EntryMade = false
                            model.gameFinished = false
                            model.winnerIs = nil
                        }
                        model.stackPath.removeLast()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(model.firstDealer == nil)
                    
                    Button("Reset") {
                        model.scoreSheet.removeAll()
                        model.lineNumber = 1
                        model.p0EntryMade = false
                        model.p1EntryMade = false
                        model.firstDealer = nil
                        model.gameFinished = false
                        model.winnerIs = nil
                    }
                    .buttonStyle(.bordered)
                    .disabled(model.firstDealer == nil || model.scoreSheet.isEmpty || model.gameFinished)
                }
            }
            .padding(.top, 12)
            Spacer()
        }
        .toolbar(.hidden, for: .navigationBar) // fully hide nav bar
    }
}

#Preview {
    @Previewable @State var model = Model()
    SettingsView()
        .environment(model)
}

