//
//  UserDefaultService.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import Foundation

class UserDefaultService {
    private init() { }

    // MARK: Write & read from defaults
    static func write<T: Encodable>(model: T, forKey key: String) -> Bool {
        guard let data = try? JSONEncoder().encode(model) else { return false }

        UserDefaults.standard.set(data, forKey: key)
        return true
    }

    static func delete(from key: String) {
         UserDefaults.standard.set(nil, forKey: key)
    }
    
    static func read<T: Decodable>(modelOf type: T.Type, forKey key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }

        return try? JSONDecoder().decode(type, from: data)
    }
}

