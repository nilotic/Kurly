//
//  URLRequest.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/17.
//

import UIKit
import Foundation
import CommonCrypto
import CryptoKit

extension URLRequest {
    
    init(httpMethod: HTTPMethod, url: ServiceURL) async {
        self.init(url: url.rawValue)
        
        // Set request
        self.httpMethod = httpMethod.rawValue
        
        guard let host = url.rawValue.host, server.rawValue.contains(host) else { return }
        set(value: "gzip",                                      field: .acceptEncoding)
        set(value: UUID().uuidString,                           field: .requestID)
        set(value: ISO8601DateFormatter().string(from: Date()), field: .requestDate)
        set(value: Bundle.main.bundleIdentifier ?? "",          field: .bundleIdentifier)
        set(value: LocaleManager.languageCode ,                 field: .acceptLanguage)
        set(value: Locale.current.regionCode ?? "",             field: .countryCode)
        set(value: await VersionManager.shared.current,         field: .appVersion)
        set(value: "iOS",                                       field: .platform)
        
        await set(value: UIDevice.current.systemVersion,        field: .platformVersion)
        await set(value: UIDevice.current.model,                field: .deviceMode)
    }
    
    init(httpMethod: HTTPMethod, url: URL) {
        self.init(url: url)
        
        // Set request
        self.httpMethod = httpMethod.rawValue
    }
}

extension URLRequest {
    
    mutating func set(value: HTTPHeaderValue, field: HTTPHeaderField) {
        setValue(value.rawValue, forHTTPHeaderField: field.rawValue)
    }
    
    mutating func set(value: String, field: HTTPHeaderField) {
        setValue(value, forHTTPHeaderField: field.rawValue)
    }
    
    mutating func add(value: HTTPHeaderValue, field: HTTPHeaderField) {
        addValue(value.rawValue, forHTTPHeaderField: field.rawValue)
    }
    
    mutating func add(value: String, field: HTTPHeaderField) {
        addValue(value, forHTTPHeaderField: field.rawValue)
    }
}
 
extension URLRequest {
    
    var debugDescription: String {
        return """
               Request
               URL
               \(httpMethod ?? "") \(url?.absoluteString ?? "")\n
               HeaderField
               \(allHTTPHeaderFields?.debugDescription ?? "")\n
               Body
               \(String(data: httpBody ?? Data(), encoding: .utf8) ?? "")
               \n\n
               """
    }
}

