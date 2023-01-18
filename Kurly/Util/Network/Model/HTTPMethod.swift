//
//  HTTPMethod.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/17.
//

import Foundation

enum HTTPMethod: String {
    case put    = "PUT"
    case post   = "POST"
    case get    = "GET"
    case delete = "DELETE"
}

extension HTTPMethod {
    
    init?(request: URLRequest?) {
        guard let string = request?.httpMethod, let method = HTTPMethod(rawValue: string) else { return nil }
        self = method
    }
}
