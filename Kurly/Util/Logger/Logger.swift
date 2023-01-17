//
//  Logger.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/17.
//

import os.log

func log(_ type: LogType = .error, _ message: Any?, file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    var logMessage = ""
    
    // Add file, function name
    if let filename = file.split(separator: "/").map(String.init).last?.split(separator: ".").map({ String($0) }).first {
        logMessage = "\(type.rawValue) [\(filename)  \(function)]\((type == .info) ? "" : " ✓\(line)")"
    }

    os_log("%s", "\(logMessage)  ➜  \(message ?? "")\n ‎‎")
    #endif
}

