//
//  PreferanceKeys.swift
//  Rummy Scorer
//
//  Created by Mark Oelbaum on 23/02/20256.
//

import SwiftUI

struct SizePreferanceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) { }
}

struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()        
    }
}
