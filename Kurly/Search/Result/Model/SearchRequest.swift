//
//  SearchRequest.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/18.
//

import Foundation

struct SearchRequest {
    let keyword: String
    let page: UInt
}

extension SearchRequest: Encodable {
    
    private enum Key: String, CodingKey {
        case keyword = "q"
        case page
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        do { try container.encode(keyword, forKey: .keyword) } catch { throw error }
        do { try container.encode(page,    forKey: .page) }    catch { throw error }
    }
}
