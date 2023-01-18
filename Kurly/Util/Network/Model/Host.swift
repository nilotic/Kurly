//
//  Host.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/17.
//

import Foundation

enum Host {
    case kurly(server: KurlyServer)
}

extension Host {
    
     var rawValue: String {
         switch self {
         case .kurly(let server):         return server.rawValue
         }
     }
     
     var url: URL {
        URL(string: rawValue)!
     }
}

extension Host {
   
    init?(rawValue: String?) {
        guard let rawValue = rawValue else { return nil }
        
        switch rawValue {
    #if DEBUG
        case Host.kurly(server: .development).rawValue:           self = .kurly(server: .development)
        case Host.kurly(server: .stage).rawValue:                 self = .kurly(server: .stage)
        case Host.kurly(server: .production).rawValue:            self = .kurly(server: .production)
            
    #else
        case Host.kurly(server: .development).rawValue:           self = .kurly(server: .production)
        case Host.kurly(server: .stage).rawValue:                 self = .kurly(server: .production)
        case Host.kurly(server: .production).rawValue:            self = .kurly(server: .production)
        
    #endif
        default:                                                    return nil
        }
    }
}
