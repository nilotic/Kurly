//
//  SearchKeywordsData.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/19.
//

import SwiftUI
import Combine
import CoreData

final class SearchKeywordsData: ObservableObject {
    
    // MARK: - Value
    // MARK: Public
    @Published private(set) var keywords = [SearchKeyword]()
    
    @Published var toastMessage = ""
    
    // MARK: Private
    private var originalKeywords = [SearchKeyword]()
    private var task: Task<Void, Never>? = nil
    
    private lazy var storeContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "SearchKeywords")
        
        #if UNITTEST
        let persistentStoreDescription  = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [persistentStoreDescription]
        #endif
        
        return persistentContainer
    }()
    
    private lazy var managedContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent      = storeContainer.viewContext
        context.mergePolicy = NSMergePolicy(merge: .mergeByPropertyStoreTrumpMergePolicyType)
        return context
    }()
    
    
    // MARK: - Function
    // MARK: Public
    func request() {
        storeContainer.loadPersistentStores { description, error in
            guard error == nil else {
                log(.error, error?.localizedDescription ?? "Failed to load persistence stores")
                return
            }
            
            let request = SearchKeywordEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            
            do {
                let result = try self.managedContext.fetch(request)
                let keywords = result.map { SearchKeyword(data: $0) }
                
                DispatchQueue.main.async {
                    self.originalKeywords = keywords
                    self.keywords         = keywords
                }
                
            } catch {
                log(.error, error.localizedDescription)
            }
        }
    }
    
    func updateAutocompletes(keyword: String) {
        Task {
            guard !keyword.isEmpty else {
                await MainActor.run { keywords = originalKeywords }
                return
            }
        
            let filtered = originalKeywords.filter { $0.keyword.contains(keyword) }
            await MainActor.run { keywords = filtered }
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
            
            await MainActor.run {
                self.originalKeywords = keywords
                self.keywords         = keywords
            }
            
            save(keywords: keywords)
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
    
    // MARK: Private
    private func save(keywords: [SearchKeyword]) {
        do {
            // Delete All
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: SearchKeywordEntity.fetchRequest())
            try managedContext.execute(deleteRequest)

            
            // Update
            for keyword in keywords {
                let entity = SearchKeywordEntity(context: managedContext)
                entity.keyword = keyword.keyword
                entity.date    = keyword.date
            }
            
            guard managedContext.hasChanges else { return }
            try managedContext.save()
            
            guard storeContainer.viewContext.hasChanges else { return }
            try storeContainer.viewContext.save()
            
        } catch {
            log(.error, error.localizedDescription)
        }
    }
}
