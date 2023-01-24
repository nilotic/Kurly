//
//  SearchCoreDataManager.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/21.
//

import SwiftUI
import CoreData

final class SearchCoreDataManager: ObservableObject {
    
    // MARK: - Singleton
    static let shared = SearchCoreDataManager()
    
    
    // MARK: - Value
    // MARK: Private
    private lazy var storeContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "Search")
        
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
    
    
    // MARK: - Initializer
    private init() { }
    
    
    // MARK: - Function
    // MARK: Public
    func requestKeywords() async throws -> [SearchKeyword] {
        try await withCheckedThrowingContinuation { continuation in
            storeContainer.loadPersistentStores { description, error in
                guard error == nil else {
                    continuation.resume(throwing: error ?? ServiceError(message:  "Failed to load persistence stores"))
                    return
                }
                
                let request = SearchKeywordEntity.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
                
                do {
                    let result = try self.managedContext.fetch(request)
                    continuation.resume(returning: result.map { SearchKeyword(data: $0) })
                    
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func requestAutocompletes(keyword: String) throws -> [SearchAutocomplete] {
        let request: NSFetchRequest<SearchKeywordEntity> = SearchKeywordEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K CONTAINS[c] %@", #keyPath(SearchKeywordEntity.keyword), keyword)
        
        let result = try managedContext.fetch(request)
        return result.map { SearchAutocomplete(data: $0) }
    }
    
    func save(keywords: [SearchKeyword]) async throws {
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
    }
    
    func delete(keyword: SearchKeyword) async throws {
        let request = SearchKeywordEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@", #keyPath(SearchKeywordEntity.keyword), keyword.keyword)
        request.fetchLimit = 1
        
        guard let object = (try managedContext.fetch(request)).first else {
            throw ServiceError(message: "Failed to find the \(keyword)")
        }
                      
        managedContext.delete(object)
        
        guard managedContext.hasChanges else { return }
        try managedContext.save()
        
        guard storeContainer.viewContext.hasChanges else { return }
        try storeContainer.viewContext.save()
    }

    func removeAll() async throws {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: SearchKeywordEntity.fetchRequest())
        try managedContext.execute(deleteRequest)
        
        guard managedContext.hasChanges else { return }
        try managedContext.save()
        
        guard storeContainer.viewContext.hasChanges else { return }
        try storeContainer.viewContext.save()
    }
}
