//
//  SearchKeywordsView.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/18.
//

import SwiftUI

struct SearchKeywordsView: View {
    
    // MARK: - Value
    // MARK: Private
    @StateObject private var data = SearchKeywordsData()
    @EnvironmentObject private var searchData: SearchData
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        VStack(spacing: 0) {
            headerView
        
            switch data.keywords.isEmpty {
            case false:     keywordsView
            case true:      emptyView
            }
        
            footerView
        }
    }
    
    // MARK: Private
    private var headerView: some View {
        Text("search_recently_searched_keyword")
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(Color("neutral0"))
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 48)
    }
    
    private var keywordsView: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(data.keywords) { keyword in
                    SearchKeywordView(data: keyword) {
                        data.handle(keyword: keyword)
                        
                    } removeAction: {
                        data.delete(keyword: keyword)
                    }
                }
            }
        }
        .frame(height: min(CGFloat(data.keywords.count) * 48, 480))
    }
    
    private var emptyView: some View {
        GeometryReader { proxy in
            ZStack {
                Color("neutral10")
                
                VStack(spacing: 20) {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 46 ,height: 46)
                        .foregroundColor(Color("neutral5"))
                    
                    Text("search_empty_searched_keyword")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color("neutral2"))
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, proxy.size.height / 2.5)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    @ViewBuilder
    private var footerView: some View {
        if !data.keywords.isEmpty {
            ZStack(alignment: .bottomTrailing) {
                Button {
                    data.deleteAll()
                    
                } label: {
                    Text("search_delete_all")
                        .font(.system(size: 14))
                        .foregroundColor(Color("alert"))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 20))
                }
                .frame(height: 48)
                
                Color("neutral6")
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
            }
            .frame(height: 48)
        }
    }
}

#if DEBUG
struct SearchKeywordsView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = SearchKeywordsView()
            .environmentObject(SearchData())
        
        Group {
            view
                .previewDevice("iPhone 8")
                .preferredColorScheme(.light)
            
            view
                .previewDevice("iPhone 11 Pro")
                .preferredColorScheme(.dark)
        }
    }
}
#endif
