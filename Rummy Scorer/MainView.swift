//
//  MainView.swift
//  Rummy Scorer
//
//  Created by Mark Oelbaum on 24/02/2026.
//

import SwiftUI

struct MainView: View {
    
    @Environment(Model.self) var model
    
    @State private var p1Width: CGFloat = 0
    @State private var p1RightEdge: CGFloat = 400
    @State private var p0TotalWidth: CGFloat = 0
    @State private var p1TotalWidth: CGFloat = 0
    
    var body: some View {
        @Bindable var model = model
        NavigationStack(path: $model.stackPath) {
            ShowScoring()
                .safeAreaInset(edge: .bottom) {
                    VStack(spacing: 15) {
                        Divider()
                        
                        ZStack(alignment: .topLeading) {
                            // Keep layout height
                            Color.clear.frame(height: 0)

                            GeometryReader { proxy in
                                Text("\(model.p0Total)")
                                    .font(.title2.bold())
                                .foregroundStyle(model.gameFinished && (model.winnerIs == 0 || model.winnerIs == 2) ? .green : .primary)
                                    .readSize(onChange: { object in p0TotalWidth = object.width })
                                    .position(x: model.p0TotalRightEdge - (p0TotalWidth / 2) + 5, y: proxy.size.height / 2)
                                Text("\(model.p1Total)")
                                    .font(.title2.bold())
                                    .foregroundStyle(model.gameFinished && (model.winnerIs == 1 || model.winnerIs == 2) ? .green : .primary)
                                    .readSize(onChange: { object in p1TotalWidth = object.width })
                                    .position(x: model.p1TotalRightEdge - (p1TotalWidth / 2) + 5, y: proxy.size.height / 2)
                            }
                            .frame(height: 24)
                        }
                        
                        HStack {
                            Spacer()
                            NavigationLink(value: "EnterP0Full") {
                                Text("Enter Full Score")
                                    .bold()
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(model.p0EntryMade || model.gameFinished)
                            .opacity(model.p0EntryMade || model.gameFinished ? 0 : 1)
                            Spacer()
                            Spacer()
                            NavigationLink(value: "EnterP1Full") {
                                Text("Enter Full Score")
                                    .bold()
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(model.p1EntryMade || model.gameFinished)
                            .opacity(model.p1EntryMade || model.gameFinished ? 0 : 1)
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            NavigationLink(value: "EnterP0Total") {
                                Text("Enter Total Score")
                            }
                            .buttonStyle(.bordered)
                            .disabled(model.p0EntryMade || model.gameFinished)
                            .opacity(model.p0EntryMade || model.gameFinished ? 0 : 1)
                            .tint(.mint)
                            Spacer()
                            Spacer()
                            NavigationLink(value: "EnterP1Total") {
                                Text("Enter Total Score")
                            }
                            .buttonStyle(.bordered)
                            .disabled(model.p1EntryMade || model.gameFinished)
                            .opacity(model.p1EntryMade || model.gameFinished ? 0 : 1)
                            .tint(.mint)
                            Spacer()
                        }
                        
                        NavigationLink(value: "Settings") {
                            Text("Back to Settings")
                        }
                    }
                    .background(.ultraThinMaterial)
                                        
                }
            
                .navigationBarBackButtonHidden()
                .toolbar(.hidden, for: .navigationBar)
                .navigationDestination(for: String.self) { value in
                    switch value {
                    case "EnterP0Full" :
                        EnterScoresView(player: 0, type: "")
                    case "EnterP1Full" :
                        EnterScoresView(player: 1, type: "")
                    case "EnterP0Total" :
                        EnterScoresView(player: 0, type: "ETO")
                    case "EnterP1Total" :
                        EnterScoresView(player: 1, type: "ETO")
                    case "Settings":
                        SettingsView()
                    default:
                        EmptyView()
                    }
                }
        }
        .task {
            if model.player0DealsFirst == nil {
                model.stackPath.append("Settings")
            }
        }
    }
}

#Preview {
    @Previewable @State var model = Model()
    MainView()
        .environment(model)
}

