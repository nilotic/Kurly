//
//  SearchAutocompleteView.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/21.
//

import SwiftUI

struct SearchAutocompleteView: View {
    
    // MARK: - Value
    // MARK: Public
    let data: SearchAutocomplete
    var action: (() -> Void)? = nil
    
    
    // MARK: - Value
    // MARK: Public
    var body: some View {
        HStack(alignment: .bottom, spacing: 20) {
            keywordView
            dateView
        }
        .frame(height: 48)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .background(Color("neutral10"))
        .onTapGesture {
            action?()
        }
    }
    
    // MARK: Private
    private var keywordView: some View {
        Text(data.keyword)
            .font(.system(size: 18))
            .foregroundColor(Color("neutral1"))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var dateView: some View {
        Text(data.date.converted.loacalizedFormattedString(dateFormat: .format3))
            .font(.system(size: 12))
            .foregroundColor(Color("neutral2"))
    }
}

#if DEBUG
struct SearchAutocompleteView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = SearchAutocompleteView(data: .placeholder)
        
        view
            .previewDevice("iPhone 8")
            .preferredColorScheme(.light)
        
        view
            .previewDevice("iPhone 11 Pro")
            .preferredColorScheme(.dark)
    }
}
#endif
