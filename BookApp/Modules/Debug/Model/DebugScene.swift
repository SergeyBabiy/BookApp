//
//  DebugScene.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import Foundation

enum DebugScene: CaseIterable {
    case home
    case test
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .test:
            return "Test screen"
        }
    }
}
