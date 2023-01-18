//
//  SearchData.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/17.
//

import SwiftUI

final class SearchData: ObservableObject {
    
    // MARK: - Value
    // MARK: Public
    @Published var keyword = ""
    
    @Published private(set) var recentlySearchedKeywords = [String]()
    
    @Published private(set) var autoCompletes = [String]()
    
}
