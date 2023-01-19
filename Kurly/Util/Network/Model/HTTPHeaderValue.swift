//
//  HTTPHeaderValue.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/17.
//

import Foundation

enum HTTPHeaderValue {
    case utf8
    case application(HTTPHeaderApplicationType)
    case multipart(MultipartType)
}

extension HTTPHeaderValue {
    
    var rawValue: String {
        switch self {
        case .utf8:                         return "charset=utf-8"
        case .application(let type):        return "application/\(type.rawValue)"
        case .multipart(let type):          return "multipart/\(type.rawValue)"
        }
    }
}
