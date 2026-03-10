//
//  ShowScoring.swift
//  Rummy Scorer
//
//  Created by Mark Oelbaum on 18/02/2026.
//

import SwiftUI

struct ShowScoring: View {
    
    @Environment(Model.self) var model
    
    @State private var p0RightEdge: CGFloat = 0
    @State private var p1RightEdge: CGFloat = 0
    @State private var p0Width: CGFloat = 0
    @State private var p1Width: CGFloat = 0
    @State private var leftGroupStartX: CGFloat = 0
    @State private var leftGroupEndX: CGFloat = 0
    @State private var rightGroupStartX: CGFloat = 0
    @State private var rightGroupEndX: CGFloat = 0
    
    var body: some View {
        VStack {
            Color.clear.frame(height: 25)
            
            HStack(spacing: 0) {
                Text("+")
                    .frame(width: 30, alignment: .trailing)
                    .getFramePosition(coordinateSpace: .named("header")) { frame in
                        leftGroupStartX = frame.minX
                    }
                Spacer()
                Text("-")
                    .frame(width: 30, alignment: .trailing)
                Spacer()
                Text("Total")
                    .frame(width: 50, alignment: .trailing)
                    .getFramePosition(coordinateSpace: .named("header")) { frame in
                        p0RightEdge = frame.maxX
                        leftGroupEndX = frame.maxX
                    }
                    .getFramePosition(coordinateSpace: .global) { frame in
                        model.p0TotalRightEdge = frame.maxX
                    }
                Spacer()
                Text("Dealer").bold()
                    .frame(width: 60)
                Spacer()
                Text("+")
                    .frame(width: 30, alignment: .trailing)
                    .getFramePosition(coordinateSpace: .named("header")) { frame in
                        rightGroupStartX = frame.minX
                    }
                Spacer()
                Text("-")
                    .frame(width: 30, alignment: .trailing)
                Spacer()
                Text("Total")
                    .frame(width: 50, alignment: .trailing)
                    .getFramePosition(coordinateSpace: .named("header")) { frame in
                        p1RightEdge = frame.maxX
                        rightGroupEndX = frame.maxX
                    }
                    .getFramePosition(coordinateSpace: .global) { frame in
                        model.p1TotalRightEdge = frame.maxX
                    }
            }
            .overlay(alignment: .topLeading) {
                ZStack(alignment: .topLeading) {
                    Text(model.players[0])
                        .font(.title2.bold())
                        .getFramePosition(coordinateSpace: .named("header")) { frame in
                            p0Width = frame.width
                        }
                        .position(x: p0RightEdge - p0Width / 2, y: 0)

                    Text(model.players[1])
                        .font(.title2.bold())
                        .getFramePosition(coordinateSpace: .named("header")) { frame in
                            p1Width = frame.width
                        }
                        .position(x: p1RightEdge - p1Width / 2, y: 0)
                    
                    // Underline for player0: from leftGroupStartX to leftGroupEndX
                    Path { path in
                        let y: CGFloat = 22
                        path.move(to: CGPoint(x: leftGroupStartX, y: y))
                        path.addLine(to: CGPoint(x: leftGroupEndX, y: y))
                    }
                    .stroke(Color.secondary, lineWidth: 2)

                    // Underline for player1: from rightGroupStartX to rightGroupEndX
                    Path { path in
                        let y: CGFloat = 22
                        path.move(to: CGPoint(x: rightGroupStartX, y: y))
                        path.addLine(to: CGPoint(x: rightGroupEndX, y: y))
                    }
                    .stroke(Color.secondary, lineWidth: 2)
                }
                .padding(.top, -30)
            }
            .coordinateSpace(name: "header")
            
            ScrollView {
                
                let lastLineToWorryAbout = Int(model.lineNumber) + 1
                
                ForEach(1..<lastLineToWorryAbout, id: \.self) { i in
                    HStack(spacing: 0) {
                        let p0 = model.getFigures(forLine: i, andPlayer: 0)
                        let p1 = model.getFigures(forLine: i, andPlayer: 1)
                        
                        var p0Empty: Bool { p0.found == false }
                        var p1Empty: Bool { p1.found == false }
                        
                        var pointLeft: Bool {
                            // Ensure we handle all cases, including when player0DealsFirst is nil
                            let even = (i % 2 == 0)
                            switch (even, model.player0DealsFirst ?? true) {
                            case (true, true):
                                return true
                            case (true, false):
                                return false
                            case (false, true):
                                return false
                            case (false, false):
                                return true
                            }
                        }
                        
                        Text("\(p0.credits, default: "")")
                            .opacity(p0Empty ? 0 : 1)
                            .font(.caption)
                            .foregroundStyle(.green)
                            .frame(width: 30, alignment: .trailing)
                        Spacer()
                        Text("\(p0.debits, default: "")")
                            .opacity(p0Empty ? 0 : 1)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .frame(width: 30, alignment: .trailing)
                        Spacer()
                        Text(verbatim: String(p0.total))
                            .opacity(p0Empty ? 0 : 1)
                            .font(.headline)
                            .frame(width: 50, alignment: .trailing)
                        Spacer()
                        Image(systemName: "arrow.left")
                            .bold()
                            .rotationEffect(Angle(degrees: pointLeft ? 180 : 0))
                            .offset(x: pointLeft ? 15 : -15)
                            .opacity(p0Empty && p1Empty ? 0 : 1)
                            .foregroundStyle(.gray)
                            .frame(width: 60, alignment: .center)
                        Spacer()
                        Text("\(p1.credits, default: "")")
                            .opacity(p1Empty ? 0 : 1)
                            .font(.caption)
                            .foregroundStyle(.green)
                            .frame(width: 30, alignment: .trailing)
                        Spacer()
                        Text("\(p1.debits, default: "")")
                            .opacity(p1Empty ? 0 : 1)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .frame(width: 30, alignment: .trailing)
                        Spacer()
                        Text(verbatim: String(p1.total))
                            .opacity(p1Empty ? 0 : 1)
                            .font(.headline)
                            .frame(width: 50, alignment: .trailing)
                    }

                    
                    
                }
//                .onAppear {
//                    model.addTestData()
//                }
                
            }
        }
        .padding(.horizontal, 5)
        
//        .safeAreaInset(edge: .bottom, spacing: 1) {
//            VStack(spacing: 12) {
//                // Top divider spanning the full width of the sheet
//                Divider()
//                    .padding(.horizontal, 0)
//
////                 Totals row aligned using the same measured positions from the header
//                ZStack(alignment: .topLeading) {
//                    // Underline segments matching the three-column groups (mirrors header)
//                    Path { path in
//                        let y: CGFloat = 0
//                        path.move(to: CGPoint(x: leftGroupStartX, y: y))
//                        path.addLine(to: CGPoint(x: leftGroupEndX, y: y))
//                    }
//                    .stroke(Color.secondary.opacity(0.5), lineWidth: 1)
//
//                    Path { path in
//                        let y: CGFloat = 0
//                        path.move(to: CGPoint(x: rightGroupStartX, y: y))
//                        path.addLine(to: CGPoint(x: rightGroupEndX, y: y))
//                    }
//                    .stroke(Color.secondary.opacity(0.5), lineWidth: 1)
//
//                    // Totals centered over their respective Total columns
//                    Text("\(model.p0Total)")
//                        .font(.title2.bold())
//                        .getFramePosition(coordinateSpace: .named("header")) { frame in
//                            p0Width = frame.width
//                        }
//                        .position(x: p0RightEdge - p0Width / 2, y: 600)
//
//                    Text("\(model.p1Total)")
//                        .font(.title2.bold())
//                        .getFramePosition(coordinateSpace: .named("header")) { frame in
//                            p1Width = frame.width
//                        }
//                        .position(x: p1RightEdge - p1Width / 2, y: 600)
//                }
//                .frame(maxWidth: .infinity, minHeight: 28, alignment: .top)
//
//                // Action buttons row
//                HStack(spacing: 12) {
//                    Button(model.players[0]) {
//                        // TODO: handle player 0 action
//                    }
//                    .buttonStyle(.borderedProminent)
//
//                    Spacer()
//
//                    Button(model.players[1]) {
//                        // TODO: handle player 1 action
//                    }
//                    .buttonStyle(.borderedProminent)
//                }
//
//                // Existing New Game button stays below
//                Button("New Game") {
//                    // TODO: handle new game
//                }
//            }
//            .padding(.top, 12)
//            .padding(.horizontal, 5)
//            .frame(maxWidth: .infinity)
//            .background()
//        }
        .padding(.top, 0.5)
    }
}


#Preview {
    @Previewable @State var model = Model()
    ShowScoring()
        .environment(model)
}

