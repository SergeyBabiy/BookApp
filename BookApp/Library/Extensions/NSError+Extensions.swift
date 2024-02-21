//
//  NSError+Extensions.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import Foundation

struct BaseNSErrorKey {
    static let title = "title"
    static let description = NSLocalizedDescriptionKey
    static let responseCode = "responseCode"
    static let endPoint = "endPoint"
}

extension NSError {
    static func error(title: String? = nil, _ message: String, code: Int = 0, domain: String = "com.example.error", function: String = #function, file: String = #file, line: Int = #line) -> NSError {

        let functionKey = "\(domain).function"
        let fileKey = "\(domain).file"
        let lineKey = "\(domain).line"

        let error = NSError(domain: domain, code: code, userInfo: [
            NSLocalizedDescriptionKey: message,
            functionKey: function,
            fileKey: file,
            BaseNSErrorKey.title: title ?? "",
            lineKey: line
        ])
        return error
    }
    
    static let unknown = NSError.error("Unknown error.")
    
    static func absentInternet() -> Error {
        return NSError.error(InternetReachbilityManager.Error.noConnection)
    }
    
    func alertContent() -> (title: String, message: String) {
        let title = (self.userInfo[BaseNSErrorKey.title] as? String) ?? ""
        let message = (self.userInfo[BaseNSErrorKey.description] as? String) ?? ""
        
        return (title: title, message: message)
    }
}

