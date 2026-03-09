//
//  TotalItemsView.swift
//  Rummy Scorer
//
//  Created by Mark Oelbaum on 05/03/2026.
//


import SwiftUI

struct TotalItemsView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(0..<50) { index in
                        Text("Item \(index)")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            // --- THE SOLUTION ---
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 10) {
                    Divider()
                    HStack {
                        Text("Total:")
                            .font(.headline)
                        Spacer()
                        Text("$100.00")
                            .font(.title3)
                            .bold()
                    }
                    
                    HStack {
                        Button("Cancel") {}
                            .buttonStyle(.bordered)
                        Spacer()
                        Button("Confirm") {}
                            .buttonStyle(.borderedProminent)
                    }
                }
                .padding()
                .background(.ultraThinMaterial) // Optional: Material for better visibility
            }
            // --------------------
            .navigationTitle("Checkout")
        }
    }
}

#Preview {
//    @Previewable @State var model = Model()
    TotalItemsView()
//        .environment(model)
}
