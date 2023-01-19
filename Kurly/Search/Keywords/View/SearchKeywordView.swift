//
//  SearchKeywordView.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/18.
//

import SwiftUI

struct SearchKeywordView: View {
    
    // MARK: - Value
    // MARK: Public
    let data: SearchKeyword
    var action: (() -> Void)? = nil
    var removeAction: (() -> Void)? = nil
    
    
    // MARK: - Value
    // MARK: Public
    var body: some View {
        HStack(spacing: 0) {
            keywordView
            removeButton
        }
        .frame(height: 48)
        .frame(maxWidth: .infinity, alignment: .leading)
        .onTapGesture {
            action?()
        }
    }
    
    // MARK: Private
    private var keywordView: some View {
        Text(data.keyword)
            .font(.system(size: 18))
            .foregroundColor(Color("neutral2"))
            .padding(.leading, 20)
    }
    
    private var removeButton: some View {
        Button {
            removeAction?()
            
        } label: {
            ZStack {
                Color("neutral8")
                
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 8, height: 8)
                    .foregroundColor(Color("neutral0"))
            }
            .frame(width: 24, height: 24)
            .cornerRadius(12)
            .padding(EdgeInsets(top: 9, leading: 0, bottom: 0, trailing: 8))
        }
        .frame(width: 44, height: 44, alignment: .topTrailing)
    }
}

#if DEBUG
struct SearchKeywordView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = SearchKeywordView(data: .placeholder)
        
        view
            .previewDevice("iPhone 8")
            .preferredColorScheme(.light)
        
        view
            .previewDevice("iPhone 11 Pro")
            .preferredColorScheme(.dark)
    }
}
#endif
