//
//  ToastModifier.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/19.
//

import SwiftUI

struct ToastModifier {
    
    // MARK: - Value
    // MARK: Public
    @Binding var message: String
    
    // MARK: Private
    @State private var workItem: DispatchWorkItem? = nil
    
    
    // MARK: - View
    // MARK: Private
    private var toastView: some View {
        GeometryReader { proxy in
            ZStack {
                if !message.isEmpty {
                    ZStack {
                        Text(LocalizedStringKey(message))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color("neutral10"))
                            .multilineTextAlignment(.leading)
                            .padding(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20))
                    }
                    .background(Color("neutral0"))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.32), radius: 16, x: 0, y: 8)
                    .compositingGroup()
                    .padding(.horizontal, 12)
                    .transition(AnyTransition.scale(scale: 1).combined(with: .opacity))
                    .padding(.bottom, proxy.safeAreaInsets.bottom < 100 ? 48 - proxy.safeAreaInsets.bottom : 12)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .animation(.spring(), value: !message.isEmpty)
        }
    }
    
    
    // MARK: - Function
    // MARK: Private
    private func dismiss() {
        workItem?.cancel()
        
        let task = DispatchWorkItem {
            withAnimation(.spring()) {
                message = ""
            }
        }
        workItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: task)
    }
}

extension ToastModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .overlay(toastView)
            .onChange(of: message) {
                guard !$0.isEmpty else { return }
                dismiss()
            }
    }
}

#if DEBUG
struct ToastModifier_Previews: PreviewProvider {
    
    static var previews: some View {
        let backgroundView = Color.clear
            .frame(maxWidth:. infinity)
        
        let view = VStack(spacing: 0) {
            backgroundView
                .toast(message: .constant("토스트 메세지 팝업입니다."))
            
            backgroundView
                .toast(message: .constant("토스트 메세지 팝업입니다. 토스트 메세지"))
            
            backgroundView
                .toast(message: .constant("토스트 메세지 팝업입니다. 토스트 메세지 팝업입니다. 토스트 메세지 팝업입니다."))
            
            backgroundView
                .toast(message: .constant("토스트 메세지 팝업입니다.\n토스트 메세지 팝업입니다. 토스트 메세지 팝업입니다."))
            
            backgroundView
                .toast(message: .constant("토스트 메세지 팝업입니다.\n토스트 메세지 팝업입니다.\n토스트 메세지 팝업입니다."))
        }
        
        return Group {
            view
                .previewDevice("iPhone 11 Pro")
                .preferredColorScheme(.light)
            
            view
                .previewDevice("iPhone 11 Pro")
                .preferredColorScheme(.dark)
        }
    }
}
#endif
