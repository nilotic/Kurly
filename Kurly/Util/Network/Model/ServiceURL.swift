//
//  ServiceURL.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/17.
//

import Foundation

enum ServiceURL {
    case search
}

extension ServiceURL {
    
    init?(url: URL?) {
        guard let url = url else { return nil }
        switch url {
        // Collection
        case ServiceURL.search.rawValue:        self = .search
        default:                                return nil
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
        case .search:       return URL(string: "\(Host.kurly(server: server).rawValue)/v3/search")!
        }
    }
}
