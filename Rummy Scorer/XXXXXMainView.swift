//
//  MainView.swift
//  Rummy Scorer
//
//  Created by Mark Oelbaum on 24/02/2026.
//

import SwiftUI

struct XXXXXMainView: View {
    
    @Environment(Model.self) var model
    
    var body: some View {
        @Bindable var model = model
        NavigationStack(path: $model.stackPath) {
            Spacer()
            VStack(spacing: 15) {
                NavigationLink(value: "EnterP0Full") {
                    Text("Enter Full Score for Player 1")
                }
                NavigationLink(value: "EnterP0Total") {
                    Text("Enter Total Score for Player 1")
                }
                
                NavigationLink(value: "EnterP1Full") {
                    Text("Enter Full Score for Player 2")
                }
                NavigationLink(value: "EnterP1Total") {
                    Text("Enter Total Score for Player 2")
                }
                
                NavigationLink(value: "Settings") {
                    Text("Back to Settings")
                }
            }
            .navigationBarBackButtonHidden()
            .toolbar(.hidden, for: .navigationBar)
//            .navigationDestination(for: String.self) { value in
//                switch value {
//                case "EnterP0Full" :
//                    EnterScoresView(player: 1)
//                case "EnterP1Full" :
//                    EnterScoresView(player: 2)
//                case "EnterP0Total" :
//                    EnterScoresView(player: 1)
//                case "EnterP1Total" :
//                    EnterScoresView(player: 2)
//                case "Settings":
//                    SettingsView()
//                default:
//                    SettingsView()
//                }
//                
//
//                
//            }
        }

//        .task {
//            //                if model.player0DealsFirst == nil {
//            model.stackPath.append("Settings")
//            //                }
//        }
    }
}

#Preview {
    @Previewable @State var model = Model()
    MainView()
        .environment(model)
}

