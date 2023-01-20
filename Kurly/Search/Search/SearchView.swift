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
            contentsView
                .navigationTitle("Search")
        }
        .navigationViewStyle(.stack)
        .searchable(text: $data.keyword, prompt: String(localized: "search_searchbar_placeholder"))
        .onSubmit(of: .search) {
            data.submittedKeyword = data.keyword
        }
    }
    
    // MARK: Private
    private var contentsView: some View {
        ZStack {
            SearchKeywordsView()
                .opacity(data.keyword.isEmpty ? 1 : 0)
                .environmentObject(data)
            
            SearchResultView()
                .opacity(data.keyword.isEmpty ? 0 : 1)
                .environmentObject(data)
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
