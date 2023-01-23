//
//  ViewExtension.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/19.
//

import SwiftUI

extension View {
    
    func toast(message: Binding<String>) -> some View {
        modifier(ToastModifier(message: message))
    }
}
