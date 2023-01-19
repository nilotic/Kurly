//
//  KurlyServer.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/17.
//

import Foundation

var server: KurlyServer = .stage {
    didSet {
        UserDefaults(suiteName: UserDefaultsKey.suiteName)?.set(server.rawValue, forKey: UserDefaultsKey.kurlyServer)
        UserDefaults(suiteName: UserDefaultsKey.suiteName)?.synchronize()
    }
}

enum KurlyServer {
    case development
    case stage
    case production
}

extension KurlyServer {
    
    var rawValue: String {
        switch self {
        #if DEBUG
        case .development:  return "https://api.github.com"
        case .stage:        return "https://api.github.com"
        case .production:   return "https://api.github.com"
        
        #else
        default:            return "https://api.github.com"
        #endif
        }
    }
}

extension KurlyServer: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension KurlyServer: CustomDebugStringConvertible {
    
    var debugDescription: String {
        #if DEBUG
        switch self {
        case .development:  return "Development"
        case .stage:        return "Stage"
        case .production:   return "Production"
        }
        
        #else
        return ""
        #endif
    }
}
