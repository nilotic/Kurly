//
//  SearchAutocompletesView.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/20.
//

import SwiftUI

struct SearchAutocompletesView: View {
    
    // MARK: - Value
    // MARK: Private
    @StateObject private var data = SearchAutocompletesData()
    @EnvironmentObject private var searchData: SearchData
    
    @Environment(\.isSearching) var isSearching
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        contentsView
            .onChange(of: searchData.keyword) {
                data.request(keyword: $0)
            }
            .onAppear {
                data.request(keyword: searchData.keyword)
            }
    }
    
    // MARK: Private
    private var contentsView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(data.autocompletes) { autocomplete in
                    SearchAutocompleteView(data: autocomplete) {
                        searchData.keyword          = autocomplete.keyword
                        searchData.submittedKeyword = autocomplete.keyword
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .opacity(isSearching ? (searchData.submittedKeyword == searchData.keyword ? 0 : 1) : 0)
    }
}

#if DEBUG
struct SearchAutocompletesView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = SearchAutocompletesView()
            .environmentObject(SearchData())
        
        view
            .previewDevice("iPhone 8")
            .preferredColorScheme(.light)
        
        view
            .previewDevice("iPhone 11 Pro")
            .preferredColorScheme(.dark)
    }
}
#endif
