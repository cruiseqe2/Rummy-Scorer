//
//  Test.swift
//  Rummy Scorer
//
//  Created by Mark Oelbaum on 21/02/2026.
//

import SwiftUI

struct Test: View {
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 10, pinnedViews: .sectionHeaders) {
                Section {
                    ForEach(1..<100) { i in
                        Text("Test \(i)")
                            .frame(width: 100, alignment: .leading)
                    }
                    } header: {
                        Text("Header")
                            .font(.headline)
                            .foregroundColor(.secondary)
//                            .padding(.horizontal)
                            .padding(.bottom, 5)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .shadow(color: Color(.systemGray4), radius: 4, x: 0, y: 0)
                        Divider()
                    }
                }
            }
        .safeAreaInset(edge: .bottom, spacing: 10) {
            HStack {
                Text("Fred")
                Spacer()
                Text("Mary")
            }
            .padding(.top, 20)
            .frame(maxWidth: .infinity)
                .background()
//                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
//                .padding(.horizontal)
//                .padding(.vertical, 6)
        }
        .padding(.top, 0.5)
            .padding(.horizontal)
        }
    }



#Preview {
    Test()
}
