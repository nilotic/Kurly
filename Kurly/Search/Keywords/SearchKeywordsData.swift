//
//  SearchKeywordsData.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/19.
//

import SwiftUI
import Combine

final class SearchKeywordsData: ObservableObject {
    
    // MARK: - Value
    // MARK: Public
    @Published private(set) var keywords = [SearchKeyword]()
    @Published private(set) var isProgressing = false
    
    @Published var toastMessage = ""
    
    // MARK: Private
    private var originalKeywords = [SearchKeyword]()
    private var task: Task<Void, Never>? = nil
    
    
    // MARK: - Function
    // MARK: Public
    func request() {
        Task {
            await MainActor.run { isProgressing = true }
            
            do {
                let keywords = try await SearchCoreDataManager.shared.requestKeywords()
                
                await MainActor.run {
                    isProgressing = false
                    
                    originalKeywords = keywords
                    self.keywords    = keywords
                }
                
            } catch {
                await MainActor.run {
                    isProgressing = false
                    toastMessage = error.localizedDescription
                }
            }
        }
    }
    
    func handle(keyword: SearchKeyword) {
        Task {
            var updatedKeywords = originalKeywords
            
            if let index = updatedKeywords.firstIndex(where: { $0 == keyword }) {
                var searchKeyword = updatedKeywords.remove(at: index)
                searchKeyword.date = Date()
                
                updatedKeywords.insert(searchKeyword, at: 0)
                
            } else {
                updatedKeywords.insert(keyword, at: 0)
                updatedKeywords = Array(updatedKeywords.prefix(10))
            }
            
            let keywords = updatedKeywords
            SearchCoreDataManager.shared.save(keywords: keywords)
            
            await MainActor.run {
                self.originalKeywords = keywords
                self.keywords         = keywords
            }
        }
    }
    
    func delete(keyword: SearchKeyword) {
        task?.cancel()
        
        task = Task {
            var updatedKeywords = keywords
            
            guard let index = updatedKeywords.firstIndex(where: { $0 == keyword }) else { return }
            updatedKeywords.remove(at: index)
            
            let keywords = updatedKeywords
            
            await MainActor.run {
                self.originalKeywords = keywords
                
                withAnimation(.spring(response: 0.38, dampingFraction: 0.9)) {
                    self.keywords = keywords
                }
            }
        }
    }
    
    func deleteAll() {
        task?.cancel()
        
        task = Task {
            await MainActor.run {
                self.originalKeywords = []
                
                withAnimation(.spring(response: 0.38, dampingFraction: 0.9)) {
                    self.keywords = []
                }
            }
        }
    }
}
