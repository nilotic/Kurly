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
        .searchable(text: $data.keyword, placement: .navigationBarDrawer(displayMode: .always), prompt: String(localized: "search_searchbar_placeholder"))
        .autocapitalization(.none)
        .disableAutocorrection(true)
        .onSubmit(of: .search) {
            data.submittedKeyword = data.keyword
        }
    }
    
    // MARK: Private
    private var contentsView: some View {
        ZStack {
            SearchKeywordsView()
                .environmentObject(data)
            
            SearchAutocompletesView()
                .environmentObject(data)
            
            SearchResultView()
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
