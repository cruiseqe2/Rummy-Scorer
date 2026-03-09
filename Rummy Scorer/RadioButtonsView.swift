//
//  RadioButtonsView.swift
//  Rummy Scorer
//
//  Created by Mark Oelbaum on 08/03/2026.
//

import SwiftUI

struct RadioButtonsView<T: Identifiable & Hashable, Content: View>: View {
    let options: [T]
    @Binding var selection: T?
    @ViewBuilder let content: (T) -> Content
    
    init(
        _ options: [T],
        selection: Binding<T?>,
        content: @escaping (T) -> Content
    ) {
        self.options = options
        self._selection = selection
        self.content = content
    }
    
    var body: some View {
        Group {
            ForEach(options, id: \.self) { option in
                Button {
                    selection = option
                } label: {
                    content(option)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
    


//#Preview {
//    RadioButtonsView()
//}
