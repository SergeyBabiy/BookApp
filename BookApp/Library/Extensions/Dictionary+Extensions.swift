//
//  Dictionary+Extensions.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import Foundation

extension Dictionary {
    func merge(dict: [Key: Value]) -> [Key: Value]{
        var temp = self
        for (k, v) in dict {
            temp.updateValue(v, forKey: k)
        }
        return temp
    }
    
    mutating func mergeToSelf(dict: [Key: Value]) {
        for (k, v) in dict {
            self.updateValue(v, forKey: k)
        }
    }
}
