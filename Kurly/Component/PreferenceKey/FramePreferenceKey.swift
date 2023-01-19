//
//  FramePreferenceKey.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/19.
//

import SwiftUI

struct FramePreferenceKey: PreferenceKey {
    
    static var defaultValue: CGRect = .zero
  
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}
