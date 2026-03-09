//
//  EnterTotalsSheet.swift
//  Rummy Scorer
//
//  Created by Mark Oelbaum on 09/03/2026.
//

import SwiftUI

struct EnterTotalsSheet: View {
    
    var player: Int
    
    @State private var totalScore: Int = 0
    
    @Environment(Model.self) var model
    @Environment(\.dismiss) var dismiss
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            VStack(spacing: 0) {
                Text("Enter Score for")
                    .font(.title.bold())
                    .foregroundStyle(Color(.systemTeal))
                    .frame(maxWidth: .infinity)
                
                Text("\(model.players[player])")
                    .font(.title.bold())
                    .foregroundStyle(Color(.systemTeal))
                    .frame(maxWidth: .infinity)
            }
            .padding(.top, 20)
            .padding(.vertical, 40)
            
            TextField("Score", value: $totalScore, formatter: numberFormatter)
                .keyboardType(.decimalPad)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .textFieldStyle(SystemTealBorder())
                .padding(.horizontal, 20)
        }
        HStack(spacing: 60) {
//            Spacer()
            Button {
                dismiss()
            } label: {
                Text("Cancel")
                    .font(.headline.bold())
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
            }
            .buttonStyle(.bordered)
//            Spacer()
//            Spacer()
//            Spacer()
            Button {
                model.addScoreEntry(scoreLine: model.lineNumber, playerNumber: player, total: totalScore)
                dismiss()
            } label: {
                Text("Add Total")
                    .font(.headline.bold())
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.top, 40)
        .padding(.bottom, 35)
        .padding(.horizontal, 20)
        
//        Spacer()
    }
}

#Preview {
    @Previewable @State var model = Model()
    EnterTotalsSheet(player: 1)
        .environment(model)
}


struct SystemTealBorder: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color(.systemTeal), lineWidth:2)
            )
    }
}
