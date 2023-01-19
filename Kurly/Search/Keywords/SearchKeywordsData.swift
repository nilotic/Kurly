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
    @Published private(set) var keywords = SearchKeyword.keywords //[SearchKeyword]()
    
    // MARK: Private
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
                
                DispatchQueue.main.async { self.keywords = keywords }
                
            } catch {
                log(.error, error.localizedDescription)
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
                withAnimation(.spring(response: 0.38, dampingFraction: 0.9)) {
                    self.keywords = []
                }
            }
        }
    }
}
