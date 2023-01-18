//
//  MultipartType.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/17.
//

import Foundation

enum MultipartType {
    case alternative
    case byteranges
    case digest
    case formData(String)
    case mixed
    case parallel
    case related
    case report
    case signed
    case encrypted
}

extension MultipartType {
    
    var rawValue: String {
        switch self {
        case .alternative:              return "alternative"
        case .byteranges:               return "byteranges"
        case .digest:                   return "digest"
        case .formData(let boundary):   return "form-data\(boundary != "" ? ";boundary=\(boundary)" : "")"
        case .mixed:                    return "mixed"
        case .parallel:                 return "parallel"
        case .related:                  return "related"
        case .report:                   return "report"
        case .signed:                   return "signed"
        case .encrypted:                return "encrypted"
        }
    }
}
