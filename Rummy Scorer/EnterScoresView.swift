//
//  EnterScoresView.swift
//  Rummy Scorer
//
//  Created by Mark Oelbaum on 24/02/2026.
//

import SwiftUI

struct EnterScoresView: View {
    
    var player: Int
    var type: String
    
    @Environment(Model.self) var model
    @Environment(\.dismiss) var dismiss
    
    @State private var buttonCounts: [Int] = Array(repeating: 0, count: 24)
    @State private var addTotal: Int = 0
    @State private var subtractTotal: Int = 0
    @State private var j: Int = 0
    
    @State private var showTotalScreen: Bool = false
    
    private var grandTotal: Int { addTotal - subtractTotal }
    
    private var addCardCount: Int {
        // Sum counts for left two columns (indices where index % 4 is 0 or 1)
        buttonCounts.enumerated().reduce(0) { partial, pair in
            let (idx, count) = pair
            return (idx % 4 < 2) ? (partial + count) : partial
        }
    }

    private var subtractCardCount: Int {
        // Sum counts for right two columns (indices where index % 4 is 2 or 3)
        buttonCounts.enumerated().reduce(0) { partial, pair in
            let (idx, count) = pair
            return (idx % 4 >= 2) ? (partial + count) : partial
        }
    }
    
    private let headerLabels = [
        "Add", "Subtract"
    ]
    
    private let bodyLabels = [
        "Ace", "7", "Ace", "7",
        "2", "8", "2", "8",
        "3", "9", "3", "9",
        "4", "10", "4", "10",
        "5", "Ace", "5", "Ace",
        "6", "Joker", "6", "Joker"
    ]
    
    private let twoColumnLayout: [GridItem] = [
        GridItem(.flexible(), spacing: 40),   // after column 1 (between 1 & 2): large gap
        GridItem(.flexible(), spacing: 40),  // after column 2: not used
    ]
    
    private let fourColumnLayout: [GridItem] = [
        GridItem(.flexible(), spacing: 8),   // after column 1 (between 1 & 2): normal
        GridItem(.flexible(), spacing: 40),  // after column 2 (between 2 & 3): larger gap
        GridItem(.flexible(), spacing: 8),   // after column 3 (between 3 & 4): normal
        GridItem(.flexible(), spacing: 8)    // after column 4: not used
    ]
    
    private func valueFor(label: String, row: Int) -> Int {
        let lower = label.lowercased()
        if lower == "joker" {
            return model.jokerValue
        } else if lower == "ace" {
            if row == 0 { return 1 }
            if row == 5 { return 15 }
            return 1
        } else if let n = Int(lower) {
            return n
        } else {
            return 0
        }
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Text("Scoring for: \(model.players[player])")
                .font(.title.bold())
                .foregroundStyle(Color(.systemTeal))
                .frame(maxWidth: .infinity)
                .frame(height: 45)
            
            LazyVGrid(columns: twoColumnLayout, spacing: 8) {
                ForEach(0..<2, id: \.self) { index in
                    Text(String(headerLabels[index]))
                        .font(.title.bold())
                        .foregroundStyle(index == 0 ? Color(.systemGreen) : Color(.systemRed))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .padding(.vertical, 4)
                }
            }
            .padding(.horizontal)
            .overlay(alignment: .center) {
                Rectangle()
                    .fill(.separator)
                    .frame(width: 1)
                    .frame(maxHeight: .infinity)
                    .allowsHitTesting(false)
            }
            
            Rectangle()
                .fill(.separator)
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .allowsHitTesting(false)
                .padding(.horizontal)
            
            LazyVGrid(columns: fourColumnLayout, spacing: 8) {
                ForEach(0..<(min(bodyLabels.count, 24)), id: \.self) { index in
                    ZStack(alignment: .topTrailing) {
                        Button(action: {
                            let col = index % 4
                            let row = index / 4 + 1
                            let label = bodyLabels[index]
                            let value = valueFor(label: label, row: row)
                            if col < 2 {
                                addTotal += value
                            } else {
                                subtractTotal += value
                            }
                            // Increment per-button count on tap only
                            if index < buttonCounts.count {
                                buttonCounts[index] += 1
                            }
                        }) {
                            Text(String(bodyLabels[index]))
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                        }
                        .buttonStyle(.bordered)
                        .disabled(index == 2 || index == 21)
                        .disabled(index == 23 && !model.useJokers)
                        .opacity(index == 2 || index == 21 ? 0 : 1)
                        .opacity(index == 23 && !model.useJokers ? 0 : 1)
                        .contextMenu {
                            // Show current count as a disabled label
                            Label("Count: \(buttonCounts[index])", systemImage: "number")
                                .disabled(true)
                            // Decrement action (no-op if already zero)
                            Button(role: .destructive) {
                                if buttonCounts[index] > 0 {
                                    // Compute this button's value and which total it affects
                                    let col = index % 4
                                    let row = index / 4 + 1
                                    let label = bodyLabels[index]
                                    let value = valueFor(label: label, row: row)
                                    
                                    // Decrement the per-button count
                                    buttonCounts[index] -= 1
                                    
                                    // Adjust totals in the opposite direction of a tap increment
                                    if col < 2 {
                                        // This button contributes to addTotal on tap, so subtract here
                                        addTotal -= value
                                    } else {
                                        // This button contributes to subtractTotal on tap, so subtract here
                                        subtractTotal -= value
                                    }
                                }
                            } label: {
                                Label("Decrement", systemImage: "minus.circle")
                            }
                            // Cancel option (closes menu)
                            Button("Cancel", role: .cancel) { }
                        }
                        
                        if buttonCounts[index] > 0 {
                            Text("\(buttonCounts[index])")
                                .font(.caption.bold())
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule().fill(Color.red)
                                )
                                .overlay(
                                    Capsule().stroke(.white.opacity(0.7), lineWidth: 1)
                                )
                                .offset(x: 6, y: -6)
                                .allowsHitTesting(false)
                        }
                    }
                }
            }
            .padding()
            .overlay(alignment: .center) {
                Rectangle()
                    .fill(.separator)
                    .frame(width: 1)
                    .frame(maxHeight: .infinity)
                    .allowsHitTesting(false)
            }
            .padding(.bottom, -8)
        }
        .opacity(showTotalScreen ? 0.35 : 1.0)
        .toolbar(.hidden, for: .navigationBar)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 0) {
                LazyVGrid(columns: twoColumnLayout, spacing: 8) {
                    ForEach(0..<2, id: \.self) { index in
                        Text(index == 0 ? "Cards: \(addCardCount)" : "Cards: \(subtractCardCount)")
                            .font(.callout.bold())
                            .frame(maxWidth: .infinity)
                            .opacity(showTotalScreen ? 0.01 : 1)
                    }
                }
                .padding(.vertical, 2)
                .overlay(alignment: .center) {
                    Rectangle()
                        .fill(.separator)
                        .frame(width: 1)
                        .frame(maxHeight: .infinity)
                        .allowsHitTesting(false)
                }
                .padding(.horizontal)
                LazyVGrid(columns: twoColumnLayout, spacing: 8) {
                    ForEach(0..<2, id: \.self) { index in
                        Button(action: {
                            for i in 0..<6 {
                                j = i * 4
                                if index == 1 { j += 2 }
                                buttonCounts[j] = 0
                                buttonCounts[j+1] = 0
                            }
                            if index == 0 {
                                addTotal = 0
                            } else {
                                subtractTotal = 0
                            }
                        }) {
                            Text("Reset")
                                .font(.headline.bold())
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                        }
                        .buttonStyle(.bordered)
                        .tint(.orange)
                        .opacity(showTotalScreen ? 0.25 : 1)
                    }
                }
                .padding(.top, 8)
                .overlay(alignment: .center) {
                    Rectangle()
                        .fill(.separator)
                        .frame(width: 1)
                        .frame(maxHeight: .infinity)
                        .allowsHitTesting(false)
                }
                .padding(.horizontal)
                VStack(spacing: 0) {
                    LazyVGrid(columns: twoColumnLayout, spacing: 8) {
                        ForEach(0..<2, id: \.self) { index in
                            Text(index == 0 ? "\(addTotal)" : "\(subtractTotal)")
                                .font(.title.bold())
                                .foregroundStyle(index == 0 ? Color(.systemGreen) : Color(.systemRed))
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .padding(.bottom, 4)
                        }
                    }
                    .padding(.vertical, 8)
                    .overlay(alignment: .center) {
                        Rectangle()
                            .fill(.separator)
                            .frame(width: 1)
                            .frame(maxHeight: .infinity)
                            .allowsHitTesting(false)
                    }
                    .padding(.horizontal)
                    
                    Text("Points scored: \(grandTotal)")
                        .foregroundStyle(Color(.systemTeal))
                        .font(.largeTitle.bold())
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(.ultraThickMaterial)
                    
                    HStack {
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Text("Cancel")
                                .font(.headline.bold())
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                        }
                        .buttonStyle(.bordered)
                        Spacer()
                        Spacer()
                        Spacer()
                        Button {
                            model.addScoreEntry(scoreLine: model.lineNumber, playerNumber: player, credits: addTotal, debits: subtractTotal)
                            dismiss()
                        } label: {
                            Text("Add Figures")
                                .font(.headline.bold())
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(addCardCount + subtractCardCount < 7)
                        Spacer()
                    }
                    .padding(.top, 24)
                    .padding(.horizontal)
                }
            }
        }
        .sheet(isPresented: $showTotalScreen, onDismiss: { dismiss() }) {
            EnterTotalsSheet(player: player)
                .presentationDetents([.fraction(0.30)])
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled()
        }
        Spacer()
            .onAppear {
                if type == "ETO" {
                    showTotalScreen = true
                }
            }
    }
}

#Preview {
    @Previewable @State var model = Model()
    EnterScoresView(player: 1, type: "ETO")
        .environment(model)
}






//
//  Trial.swift
//  Rummy Scorer
//
//  Created by Mark Oelbaum on 08/02/2026.
//

//import SwiftUI
//
//struct EqualGridButtons: View {
//
//    @Environment(Model.self) var model
//
//    @State private var addTotal: Int = 0
//    @State private var subtractTotal: Int = 0
//    @State private var j: Int = 0
//    private var grandTotal: Int { addTotal - subtractTotal }
//
//    @State private var buttonCounts: [Int] = Array(repeating: 0, count: 24)
//
//    // Labels to display in the grid
//    private let headerLabels = [
//        "Add", "Subtract"
//    ]
//
//    private let bodyLabels = [
//        "Ace", "7", "Ace", "7",
//        "2", "8", "2", "8",
//        "3", "9", "3", "9",
//        "4", "10", "4", "10",
//        "5", "Ace", "5", "Ace",
//        "6", "Joker", "6", "Joker"
//    ]
//
//    private let twoColumnLayout: [GridItem] = [
//        GridItem(.flexible(), spacing: 40),   // after column 1 (between 1 & 2): large gap
//        GridItem(.flexible(), spacing: 40),  // after column 2: not used
//    ]
//
//    private let fourColumnLayout: [GridItem] = [
//        GridItem(.flexible(), spacing: 8),   // after column 1 (between 1 & 2): normal
//        GridItem(.flexible(), spacing: 40),  // after column 2 (between 2 & 3): larger gap
//        GridItem(.flexible(), spacing: 8),   // after column 3 (between 3 & 4): normal
//        GridItem(.flexible(), spacing: 8)    // after column 4: not used
//    ]
//
//    private func valueFor(label: String, row: Int) -> Int {
//        let lower = label.lowercased()
//        if lower == "joker" {
//            return 10
//        } else if lower == "ace" {
//            if row == 0 { return 1 }
//            if row == 5 { return 15 }
//            return 1
//        } else if let n = Int(lower) {
//            return n
//        } else {
//            return 0
//        }
//    }
//
//    var body: some View {
//        VStack(spacing: 0) {
//
//            Text("Scoring for: Elaine")
//                .font(.title.bold())
//                .foregroundStyle(Color(.systemTeal))
//                .frame(maxWidth: .infinity)
//                .frame(height: 45)
//
//            LazyVGrid(columns: twoColumnLayout, spacing: 8) {
//                ForEach(0..<2, id: \.self) { index in
//                    Text(String(headerLabels[index]))
//                        .font(.title.bold())
//                        .foregroundStyle(index == 0 ? Color(.systemGreen) : Color(.systemRed))
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 50)
//                        .padding(.vertical, 4)
//                }
//            }
//            .padding(.horizontal)
//            .overlay(alignment: .center) {
//                Rectangle()
//                    .fill(.separator)
//                    .frame(width: 1)
//                    .frame(maxHeight: .infinity)
//                    .allowsHitTesting(false)
//            }
//
//            Rectangle()
//                .fill(.separator)
//                .frame(height: 1)
//                .frame(maxWidth: .infinity)
//                .allowsHitTesting(false)
//                .padding(.horizontal)
//
//            LazyVGrid(columns: fourColumnLayout, spacing: 8) {
//                ForEach(0..<(min(bodyLabels.count, 24)), id: \.self) { index in
//                    ZStack(alignment: .topTrailing) {
//                        Button(action: {
//                            let col = index % 4
//                            let row = index / 4 + 1
//                            let label = bodyLabels[index]
//                            let value = valueFor(label: label, row: row)
//                            if col < 2 {
//                                addTotal += value
//                            } else {
//                                subtractTotal += value
//                            }
//                            // Increment per-button count on tap only
//                            if index < buttonCounts.count {
//                                buttonCounts[index] += 1
//                            }
//                        }) {
//                            Text(String(bodyLabels[index]))
//                                .frame(maxWidth: .infinity)
//                                .frame(height: 44)
//                        }
//                        .buttonStyle(.bordered)
//                        .disabled(index == 21)
//                        .disabled(index == 23 && !model.useJokers)
//                        .opacity(index == 21 ? 0 : 1)
//                        .opacity(index == 23 && !model.useJokers ? 0 : 1)
//                        .contextMenu {
//                            // Show current count as a disabled label
//                            Label("Count: \(buttonCounts[index])", systemImage: "number")
//                                .disabled(true)
//                            // Decrement action (no-op if already zero)
//                            Button(role: .destructive) {
//                                if buttonCounts[index] > 0 {
//                                    // Compute this button's value and which total it affects
//                                    let col = index % 4
//                                    let row = index / 4 + 1
//                                    let label = bodyLabels[index]
//                                    let value = valueFor(label: label, row: row)
//
//                                    // Decrement the per-button count
//                                    buttonCounts[index] -= 1
//
//                                    // Adjust totals in the opposite direction of a tap increment
//                                    if col < 2 {
//                                        // This button contributes to addTotal on tap, so subtract here
//                                        addTotal -= value
//                                    } else {
//                                        // This button contributes to subtractTotal on tap, so subtract here
//                                        subtractTotal -= value
//                                    }
//                                }
//                            } label: {
//                                Label("Decrement", systemImage: "minus.circle")
//                            }
//                            // Cancel option (closes menu)
//                            Button("Cancel", role: .cancel) { }
//                        }
//
//                        if buttonCounts[index] > 0 {
//                            Text("\(buttonCounts[index])")
//                                .font(.caption.bold())
//                                .foregroundStyle(.white)
//                                .padding(.horizontal, 8)
//                                .padding(.vertical, 4)
//                                .background(
//                                    Capsule().fill(Color.red)
//                                )
//                                .overlay(
//                                    Capsule().stroke(.white.opacity(0.7), lineWidth: 1)
//                                )
//                                .offset(x: 6, y: -6)
//                                .allowsHitTesting(false)
//                        }
//                    }
//                }
//            }
//            .padding()
//            .overlay(alignment: .center) {
//                Rectangle()
//                    .fill(.separator)
//                    .frame(width: 1)
//                    .frame(maxHeight: .infinity)
//                    .allowsHitTesting(false)
//            }
//            .padding(.bottom, -8)
//        }
//        .safeAreaInset(edge: .bottom) {
//            VStack(spacing: 0) {
//                LazyVGrid(columns: twoColumnLayout, spacing: 8) {
//                    ForEach(0..<2, id: \.self) { index in
//                        Button(action: {
//                            for i in 0..<6 {
//                                j = i * 4
//                                if index == 1 { j += 2 }
//                                buttonCounts[j] = 0
//                                buttonCounts[j+1] = 0
//                            }
//                            if index == 0 {
//
////                                model.addTestData()
//
//                                addTotal = 0
//                            } else {
//                                subtractTotal = 0
//                            }
//                        }) {
//                            Text("Reset")
//                                .font(.headline.bold())
//                                .frame(maxWidth: .infinity)
//                                .frame(height: 44)
//                        }
//                        .buttonStyle(.bordered)
//                        .tint(.orange)
//                    }
//                }
//                .padding(.top, 8)
//                .overlay(alignment: .center) {
//                    Rectangle()
//                        .fill(.separator)
//                        .frame(width: 1)
//                        .frame(maxHeight: .infinity)
//                        .allowsHitTesting(false)
//                }
//                .padding(.horizontal)
//                VStack(spacing: 0) {
//                    LazyVGrid(columns: twoColumnLayout, spacing: 8) {
//                        ForEach(0..<2, id: \.self) { index in
//                            Text(index == 0 ? "\(addTotal)" : "\(subtractTotal)")
//                                .font(.title.bold())
//                                .foregroundStyle(index == 0 ? Color(.systemGreen) : Color(.systemRed))
//                                .frame(maxWidth: .infinity)
//                                .frame(height: 40)
//                                .padding(.bottom, 4)
//                        }
//                    }
//                    .padding(.vertical, 8)
//                    .overlay(alignment: .center) {
//                        Rectangle()
//                            .fill(.separator)
//                            .frame(width: 1)
//                            .frame(maxHeight: .infinity)
//                            .allowsHitTesting(false)
//                    }
//                    .padding(.horizontal)
//
//                    Text("Points scored: \(grandTotal)")
//                        .foregroundStyle(Color(.systemTeal))
//                        .font(.largeTitle.bold())
//                        .padding(.vertical, 8)
//                        .frame(maxWidth: .infinity)
//                        .background(.ultraThickMaterial)
//                }
//            }
//        }
//        Spacer()
//    }
//}
//
//#Preview {
//    @Previewable @State var model = Model()
//    EqualGridButtons()
//        .environment(model)
//}
//

