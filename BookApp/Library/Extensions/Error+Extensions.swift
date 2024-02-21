//
//  Error+Extensions.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import Foundation

extension Error {
    var nsError: NSError{
        return (self as NSError)
    }
}

extension NSError {
    static var deinited: NSError { NSError.error("DEINITED.") }
}
