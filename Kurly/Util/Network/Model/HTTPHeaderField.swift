//
//  HTTPHeaderField.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/17.
//

import Foundation

enum HTTPHeaderField: String {
    case contentType      = "Content-Type"
    case contentLength    = "Content-Length"
    case accept           = "Accept"
    case acceptEncoding   = "Accept-Encoding"
    case acceptLanguage   = "Accept-Language"
    case authorization    = "Authorization"
    case origin           = "Origin"
    case referer          = "Referer"
    case platform         = "Platform"
    case platformVersion  = "Platform-Version"
    case deviceMode       = "Device-Model"
    case bundleIdentifier = "Bundle-Identifier"
    case appVersion       = "App-Version"
    case requestID        = "Request-ID"
    case requestDate      = "Request-Date"
    case countryCode      = "Country-Code"
    case signature        = "Signature"
}
