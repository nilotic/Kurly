//
//  ServiceError.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/17.
//

import Foundation

struct ServiceError: Error  {
    var code = ""
    let message: String
}

extension ServiceError {
    
    init(localized: String) {
        message = NSLocalizedString(localized, comment: "")
    }
}

extension ServiceError: LocalizedError {
    
    var errorDescription: String? {
        message
    }
}

extension ServiceError: CustomStringConvertible {
    
    var description: String {
        message
    }
}

extension ServiceError: Decodable {
    
    private enum Key: String, CodingKey {
        case code
        case message
    }
 
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
    
        do { code    = try container.decode(String.self, forKey: .code) }    catch { throw error }
        do { message = try container.decode(String.self, forKey: .message) } catch { throw error }
    }
}

