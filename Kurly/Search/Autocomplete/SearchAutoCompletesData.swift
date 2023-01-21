//
//  SearchAutoCompletesData.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/20.
//

import SwiftUI
import CoreData

final class SearchAutocompletesData: ObservableObject {
    
    // MARK: - Value
    // MARK: Public
    @Published private(set) var autocompletes = [SearchAutocomplete]()
    
    
    // MARK: - Function
    // MARK: Public
    func request(keyword: String) {
        Task {
            do {
                let autocompletes = try SearchCoreDataManager.shared.requestAutocompletes(keyword: keyword)
                    
                await MainActor.run {
                    withAnimation(.spring(response: 0.38, dampingFraction: 0.9)) {
                        self.autocompletes = autocompletes
                    }
                }
                
            } catch {
                log(.error, error.localizedDescription)
            }
        }
    }
}
