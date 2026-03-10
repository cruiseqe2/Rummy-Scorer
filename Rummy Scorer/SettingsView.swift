
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
            
            Spacer()
            
            Form {
                Section("Players") {
                    Text("Player 1: Elaine")
                    Text("Player 2: Mark")
                }
                
                Section("Options") {
                    Text("Using Jokers: Yes")
                    Text("Joker Value: 10")
                    Text("Play Up To: \(model.playUpTo)")
                }
                
                Section("First to Deal") {
                    HStack(spacing: 60) {
                        RadioButtonsView(
                            model.dealerOptions,
                            selection: $model.firstDealer) { person in
                                HStack {
                                    Image(systemName: person.name == model.firstDealer?.name ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(person.name == model.firstDealer?.name ? .blue : .primary)
                                    Text(person.name)
                                }
                            }
                    }
                    .disabled(!model.scoreSheet.isEmpty && !model.gameFinished)
                }
            }

        }
        .padding(.top, 12)
        .toolbar(.hidden, for: .navigationBar) // fully hide nav bar
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 30) {
                
                Button {
                    if model.gameFinished {
                        model.scoreSheet.removeAll()
                        model.lineNumber = 1
                        model.p0EntryMade = false
                        model.p1EntryMade = false
                        model.gameFinished = false
                        model.winnerIs = nil
                    }
                    model.stackPath.removeLast()
                } label: {
                    Text(model.scoreSheet.isEmpty || model.gameFinished ? "Play" : "Continue")
                        .font(.headline.bold())
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                }
                .buttonStyle(.borderedProminent)
                .disabled(model.firstDealer == nil)
                
                Button {
                    model.scoreSheet.removeAll()
                    model.lineNumber = 1
                    model.p0EntryMade = false
                    model.p1EntryMade = false
                    model.firstDealer = nil
                    model.gameFinished = false
                    model.winnerIs = nil
                } label: {
                    Text("Reset")
                        .font(.headline.bold())
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                }
                .buttonStyle(.bordered)
                .disabled(model.firstDealer == nil || model.scoreSheet.isEmpty || model.gameFinished)
                
            }
            .padding(.horizontal)
            .frame(height: 300)
        }
    }
}

#Preview {
    @Previewable @State var model = Model()
    SettingsView()
        .environment(model)
}

