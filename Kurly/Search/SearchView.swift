//
//  SearchView.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/17.
//

import SwiftUI

struct SearchView: View {
    
    // MARK: - Value
    // MARK: Private
    @StateObject private var data = SearchData()
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        NavigationView {
            keywordsView
        }
        .navigationViewStyle(.stack)
        .searchable(text: $data.keyword)
    }
    
    // MARK: Private
    @ViewBuilder
    private var keywordsView: some View {
        switch data.keyword.isEmpty {
        case true:      recentlySearchedKeywordsView
        case false:     autoCompletesView
        }
    }
    
    private var recentlySearchedKeywordsView: some View {
        List(data.recentlySearchedKeywords, id: \.self) {
            Text($0)
        }
    }
    
    private var autoCompletesView: some View {
        List(data.autoCompletes, id: \.self) {
            Text($0)
        }
    }
}

#if DEBUG
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        let view = SearchView()
        
        view
            .previewDevice("iPhone 8")
            .preferredColorScheme(.light)
        
        view
            .previewDevice("iPhone 11 Pro")
            .preferredColorScheme(.dark)
    }
}
#endif
