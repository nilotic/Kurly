//
//  SearchKeyword.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/18.
//

import Foundation

struct SearchKeyword {
    let keyword: String
    var date: Date
}

extension SearchKeyword {
    
    init(data: SearchKeywordEntity) {
        keyword = data.keyword ?? ""
        date    = data.date ?? Date()
    }
}

extension SearchKeyword {
    
    var rawValue: String {
        keyword
    }
}

extension SearchKeyword: Identifiable {
    
    var id: String {
        rawValue
    }
}

extension SearchKeyword: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension SearchKeyword: Equatable {
    
    static func ==(lhs: SearchKeyword, rhs: SearchKeyword) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

#if DEBUG
extension SearchKeyword {
    
    static var placeholder: SearchKeyword {
        SearchKeyword(keyword: "swift", date: Date())
    }
    
    static var keywords: [SearchKeyword] {
        [SearchKeyword(keyword: "Swift UI", date: Date()), SearchKeyword(keyword: "iOS", date: Date()), SearchKeyword(keyword: "iPadOS", date: Date()), SearchKeyword(keyword: "tvOS", date: Date()),
         SearchKeyword(keyword: "watchOS", date: Date()), SearchKeyword(keyword: "CarPlay", date: Date()), SearchKeyword(keyword: "Swift Algorithm", date: Date()), SearchKeyword(keyword: "Objective C", date: Date()),
         SearchKeyword(keyword: "macOS", date: Date()), SearchKeyword(keyword: "Swift", date: Date())]
    }
}
#endif
