//
//  VersionManager.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/17.
//

import Foundation
import Combine

final class VersionManager {
    
    // MARK: - Singleton
    static let shared = VersionManager()
    
    
    // MARK: - Initializer
    private init() { }
    
    
    // MARK: - Value
    // MARK: Public
    @MainActor
    var current: String {
        #if DEBUG
            "\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "") (\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""))"
        #else
            (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
        #endif
    }
}

