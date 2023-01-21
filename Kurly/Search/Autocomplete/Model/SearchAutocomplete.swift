//
//  SearchAutocomplete.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/21.
//

import Foundation

struct SearchAutocomplete {
    let keyword: String
    var date: Date
}

extension SearchAutocomplete {
    
    init(data: SearchKeywordEntity) {
        keyword = data.keyword ?? ""
        date    = data.date ?? Date()
    }
}

extension SearchAutocomplete {
    
    var rawValue: String {
        keyword
    }
}

extension SearchAutocomplete: Identifiable {
    
    var id: String {
        rawValue
    }
}

extension SearchAutocomplete: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension SearchAutocomplete: Equatable {
    
    static func ==(lhs: SearchAutocomplete, rhs: SearchAutocomplete) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

#if DEBUG
extension SearchAutocomplete {
    
    static var placeholder: SearchAutocomplete {
        SearchAutocomplete(keyword: "swift", date: Date())
    }
    
    static var keywords: [SearchAutocomplete] {
        [SearchAutocomplete(keyword: "Swift UI", date: Date()), SearchAutocomplete(keyword: "iOS", date: Date()), SearchAutocomplete(keyword: "iPadOS", date: Date()), SearchAutocomplete(keyword: "tvOS", date: Date()),
         SearchAutocomplete(keyword: "watchOS", date: Date()), SearchAutocomplete(keyword: "CarPlay", date: Date()), SearchAutocomplete(keyword: "Swift Algorithm", date: Date()), SearchAutocomplete(keyword: "Objective C", date: Date()),
         SearchAutocomplete(keyword: "macOS", date: Date()), SearchAutocomplete(keyword: "Swift", date: Date())]
    }
}
#endif
