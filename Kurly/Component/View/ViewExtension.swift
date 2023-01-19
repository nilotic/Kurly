//
//  ViewExtension.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/19.
//

import SwiftUI

extension View {
    
    func frame(perform: @escaping (CGRect) -> Void) -> some View {
        background(
            GeometryReader {
                Color.clear
                    .preference(key: FramePreferenceKey.self, value: $0.frame(in: .global))
            }
        )
        .onPreferenceChange(FramePreferenceKey.self) { value in
            DispatchQueue.main.async { perform(value) }
        }
    }
    
    func toast(message: Binding<String>) -> some View {
        modifier(ToastModifier(message: message))
    }
}
