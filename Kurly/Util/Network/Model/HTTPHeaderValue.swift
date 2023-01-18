//
//  HTTPHeaderValue.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/17.
//

import Foundation

enum HTTPHeaderValue {
    case applicationJSON
    case urlEncoded
    case utf8
    case utf8Endcoded
    case applicationJsonUTF8
    case multipart(MultipartType)
}

extension HTTPHeaderValue {
    
    var rawValue: String {
        switch self {
        case .applicationJSON:              return "application/json"
        case .urlEncoded:                   return "application/x-www-form-urlencoded"
        case .utf8:                         return "charset=utf-8"
        case .utf8Endcoded:                 return "application/x-www-form-urlencoded;charset=utf-8"
        case .applicationJsonUTF8:          return "application/json;charset=utf-8"
        case .multipart(let multipart):     return "multipart/\(multipart.rawValue)"
        }
    }
}
