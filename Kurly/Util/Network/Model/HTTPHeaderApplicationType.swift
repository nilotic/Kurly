//
//  HTTPHeaderApplicationType.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/18.
//

import Foundation

enum HTTPHeaderApplicationType: String {
    case urlEncoded   = "x-www-form-urlencoded"
    case utf8Endcoded = "x-www-form-urlencoded;charset=utf-8"
    case json         = "json"
    case jsonUTF8     = "json;charset=utf-8"
    case github       = "vnd.github+json"
}
