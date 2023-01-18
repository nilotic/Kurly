//
//  Response.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/17.
//

import Foundation

struct Response {
    let url: URL
    let headerFields: [AnyHashable: Any]
    let data: Data?
    let statusCode: HTTPStatusCode
}

extension Response {
    
    init(data: Data?, urlResponse: URLResponse?) throws {
        guard let urlResponse = urlResponse as? HTTPURLResponse, let url = urlResponse.url else { throw URLError(.badServerResponse) }
        
        self.url          = url
        self.headerFields = urlResponse.allHeaderFields
        self.data         = data
        
        statusCode = HTTPStatusCode(rawValue: urlResponse.statusCode) ?? .none
    }
    
    var error: Error? {
        switch statusCode.rawValue {
        case 200..<300:
            return nil
        
        default:
            guard let data = data, let error = (try? JSONDecoder().decode(ServiceError.self, from: data)) else { return URLError(.badServerResponse) }
            return error
        }
    }
}

extension Response: CustomDebugStringConvertible {
    
    var debugDescription: String {
        var headerFieldsDescription: String {
            guard let headerFields = headerFields as? [String: String] else { return headerFields.debugDescription }
            return headerFields.debugDescription
        }
        
        return """
               Response
               HTTP status: \(statusCode.rawValue)
               URL: \(url.absoluteString)\n
               HeaderField
               \(headerFieldsDescription))\n
               Data
               \(String(data: data ?? Data(), encoding: .utf8) ?? "")
               \n
               """
    }
}
