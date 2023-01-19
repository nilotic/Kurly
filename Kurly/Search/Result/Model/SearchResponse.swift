//
//  SearchResponse.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/18.
//

import Foundation

struct SearchResponse {
    let repositories: [GitHubRepository]
    let totalCount: UInt
    let isComplete: Bool
}

extension SearchResponse: Decodable {
    
    private enum Key: String, CodingKey {
        case repositories = "items"
        case totalCount   = "total_count"
        case isComplete   = "incomplete_results"
    }
 
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        do { repositories = try container.decode([GitHubRepository].self, forKey: .repositories) } catch { repositories = [] }
        do { totalCount   = try container.decode(UInt.self,               forKey: .totalCount) }   catch { throw error }
        do { isComplete   = try container.decode(Bool.self,               forKey: .isComplete) }   catch { throw error }
    }
}

#if DEBUG
extension SearchResponse {
 
    static var placeholder: SearchResponse {
        let repositories = [GitHubRepository(id: 1, name: "nilotic1.github.io", owner: .placeholder),
                            GitHubRepository(id: 2, name: "nilotic2.github.io", owner: .placeholder),
                            GitHubRepository(id: 3, name: "nilotic3.github.io", owner: .placeholder),
                            GitHubRepository(id: 4, name: "nilotic4.github.io", owner: .placeholder),
                            GitHubRepository(id: 5, name: "nilotic5.github.io", owner: .placeholder),
                            GitHubRepository(id: 6, name: "nilotic6.github.io", owner: .placeholder)]
        
        return SearchResponse(repositories: repositories, totalCount: UInt(repositories.count), isComplete: true)
    }
}
#endif
