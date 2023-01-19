//
//  GitHubRepository.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/18.
//

import Foundation

struct GitHubRepository: Identifiable {
    let id: Int
    let name: String
    let owner: GitHubRepositoryOwner
}

extension GitHubRepository {
    
    var rawValue: Int {
        id
    }
}

extension GitHubRepository: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension GitHubRepository: Equatable {
    
    static func ==(lhs: GitHubRepository, rhs: GitHubRepository) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

extension GitHubRepository: Decodable {
    
    private enum Key: String, CodingKey {
        case id
        case name
        case owner
    }
 
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        do { id    = try container.decode(Int.self,                   forKey: .id) }    catch { throw error }
        do { name  = try container.decode(String.self,                forKey: .name) }  catch { throw error }
        do { owner = try container.decode(GitHubRepositoryOwner.self, forKey: .owner) } catch { throw error }
    }
}

#if DEBUG
extension GitHubRepository {
    
    static var placeholder: GitHubRepository {
        GitHubRepository(id: 341784068, name: "nilotic3.github.io", owner: .placeholder)
    }
}
#endif
