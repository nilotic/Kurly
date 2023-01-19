//
//  SearchResultData.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/19.
//

import SwiftUI

final class SearchResultData: ObservableObject {
    
    // MARK: - Value
    // MARK: Public
    @Published private(set) var repositories     = [GitHubRepository]()
    @Published private(set) var totalCount: UInt = 0
    @Published private(set) var isProgressing    = false
    
    @Published var toastMessage = ""
    
    var formattedCountString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        guard let formattedString = numberFormatter.string(for: totalCount) else { return "" }
        
        var countString = String(format: String(localized: "%d repositories"), totalCount)
        countString = countString.replacingOccurrences(of: "\(totalCount)", with: formattedString)
        
        return countString
    }
 
    // MARK: Private
    private var keyword    = ""
    private var page: UInt = 0
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    
    // MARK: - Function
    // MARK: Public
    func request(keyword: String) {
        Task {
            await MainActor.run { isProgressing = true }
            
            do {
                let response = try await requestRepository(keyword: keyword, page: 1)
                
                await MainActor.run {
                    withAnimation(.spring(response: 0.38, dampingFraction: 0.9)) {
                        isProgressing = false
                        
                        self.keyword = keyword
                        page = 1
                        
                        repositories = response.repositories
                        totalCount   = response.totalCount
                    }
                }
                
            } catch {
                await MainActor.run {
                    isProgressing = false
                    toastMessage = error.localizedDescription
                }
            }
        }
    }
    
    func requestNext() {
        
    }
    
    // MARK: Private
    private func requestRepository(keyword: String, page: UInt) async throws -> SearchResponse {
        var request = await URLRequest(httpMethod: .get, url: .searchRepository)
        request.set(value: .application(.github), field: .accept)
        
        let response = try await NetworkManager.shared.request(urlRequest: request, requestData: SearchRequest(keyword: keyword, page: page))
        
        guard let responseData = response.data else { throw response.error ?? URLError(.badServerResponse) }
        return try decoder.decode(SearchResponse.self, from: responseData)
    }
}
