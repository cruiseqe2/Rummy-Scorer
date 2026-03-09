//
//  Extension-View.swift
//  Rummy Scorer
//
//  Created by Mark Oelbaum on 23/02/2026.
//


//
//  View.swift
//  Rummy Scorer
//
//  Created by Mark Oelbaum on 26/02/2025.
//

import SwiftUI
import Foundation

extension View {
    
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geo in
                Color.clear
                    .preference(key: SizePreferanceKey.self, value: geo.size)
            }
        )
        .onPreferenceChange(SizePreferanceKey.self) { value in
            onChange(value)
        }
    }

    func getFramePosition(coordinateSpace: CoordinateSpace = .global, closure: @escaping (CGRect) -> Void) -> some View {
        self.modifier(FrameModifier(coordinateSpace: coordinateSpace, frame: closure))
    }

}

struct FrameModifier: ViewModifier {
    let coordinateSpace: CoordinateSpace
    let frame: (CGRect) -> Void
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geo in
                    Color.clear
                        .preference(key: FramePreferenceKey.self, value: geo.frame(in: coordinateSpace))
                }
            )
            .onPreferenceChange(FramePreferenceKey.self) { frame in
                self.frame(frame)
            }
    }
}



