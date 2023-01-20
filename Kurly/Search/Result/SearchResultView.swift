//
//  SearchResultView.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/19.
//

import SwiftUI

struct SearchResultView: View {
    
    // MARK: - Value
    // MARK: Private
    @StateObject private var data = SearchResultData()
    @EnvironmentObject private var searchData: SearchData
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        ZStack {
            contentsView
            
            if data.isProgressing {
                ProgressView()
            }
        }
        .toast(message: $data.toastMessage)
        .onChange(of: searchData.submittedKeyword) {
            guard !$0.isEmpty else { return }
            data.request(keyword: $0)
        }
    }
    
    // MARK: Private
    @ViewBuilder
    private var contentsView: some View {
        switch data.repositories.isEmpty {
        case false:     repositoriesView
        case true:      emptyView
        }
    }
    
    private var repositoriesView: some View {
        VStack(spacing: 0){
            totalCountView
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(data.repositories) {
                        GitHubRepositoryView(data: $0)
                    }
                    
                    if data.nextPage != nil {
                        GitHubRepositoryProgressView()
                            .onAppear {
                                data.requestNext()
                            }
                    }
                }
            }
        }
    }
    
    private var totalCountView: some View {
        Text(data.formattedCountString)
            .font(.system(size: 14))
            .foregroundColor(Color("neutral1"))
            .frame(height: 40)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 12, leading: 20, bottom: 0, trailing: 20))
    }
    
    @ViewBuilder
    private var emptyView: some View {
        if !data.isProgressing {
            GeometryReader { proxy in
                ZStack {
                    Color("neutral10")
                    
                    VStack(spacing: 20) {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 46 ,height: 46)
                            .foregroundColor(Color("neutral5"))
                        
                        Text("search_empty_result")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color("neutral2"))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, proxy.size.height / 2.5)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

#if DEBUG
struct SearchResultView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = SearchResultView()
        
        view
            .previewDevice("iPhone 8")
            .preferredColorScheme(.light)
        
        view
            .previewDevice("iPhon 11 Pro")
            .preferredColorScheme(.dark)
    }
}
#endif
