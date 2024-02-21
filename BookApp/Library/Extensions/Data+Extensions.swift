//
//  Data+Extensions.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import Foundation

extension Data {

    init<T>(from value: T) {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }

    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.load(as: T.self) }
    }
    
    func asMegabytes() -> String {
      let bcf = ByteCountFormatter()
      bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
      bcf.countStyle = .file
        
      return bcf.string(fromByteCount: Int64(self.count))
    }
}

