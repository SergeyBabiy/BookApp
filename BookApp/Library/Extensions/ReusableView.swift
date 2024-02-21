//
//  ReusableView.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import Foundation

protocol ReusableView: class {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
