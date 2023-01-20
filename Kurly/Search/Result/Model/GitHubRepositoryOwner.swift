//
//  GitHubRepositoryOwner.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/18.
//

import Foundation

struct GitHubRepositoryOwner {
    let id: Int
    let logIn: String
    let avatarURL: URL?
    let url: URL?
}

extension GitHubRepositoryOwner: Decodable {
    
    private enum Key: String, CodingKey {
        case id
        case logIn     = "login"
        case avatarURL = "avatar_url"
        case url
    }
 
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        do { id        = try container.decode(Int.self,    forKey: .id) }         catch { throw error }
        do { logIn     = try container.decode(String.self, forKey: .logIn) }      catch { throw error }
        do { avatarURL = try container.decode(URL.self,    forKey: .avatarURL ) } catch { avatarURL = nil }
        do { url       = try container.decode(URL.self,    forKey: .url ) }       catch { url = nil }
    }
}

#if DEBUG
extension GitHubRepositoryOwner {
    
    static var placeholder: GitHubRepositoryOwner {
        GitHubRepositoryOwner(id: 79552914, logIn: "nilotic3", avatarURL: URL(string: "https://avatars.githubusercontent.com/u/79552914?v=4"), url: URL(string: "https://api.github.com/users/nilotic3"))
    }
}
#endif
