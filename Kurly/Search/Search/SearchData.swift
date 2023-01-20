//
//  SearchData.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/17.
//

import SwiftUI
import CoreData

final class SearchData: ObservableObject {
    
    // MARK: - Value
    // MARK: Public
    @Published var keyword          = ""
    @Published var submittedKeyword = ""
}
