//
//  ServiceURL.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/17.
//

import Foundation

enum ServiceURL {
    case searchRepository
}

extension ServiceURL {
    
    init?(url: URL?) {
        guard let url = url else { return nil }
        switch url {
        // Collection
        case ServiceURL.searchRepository.rawValue:      self = .searchRepository
        default:                                        return nil
        }
    }
    
    init?(components: URLComponents) {
        guard let url = URL(string: "\(components.scheme ?? "")://\(components.host ?? "")\(components.path)"), let serviceURL = ServiceURL(url: url) else { return nil }
        self = serviceURL
    }
}

extension ServiceURL {
    
    var rawValue: URL {
        switch self {
        case .searchRepository:     return URL(string: "\(Host.kurly(server: server).rawValue)/search/repositories")!
        }
    }
}
