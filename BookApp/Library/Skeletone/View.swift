//
//  View.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import UIKit

class View: UIView {
//    override var backgroundColor: UIColor?{
//        didSet{
//            print("backgroundColor: \(backgroundColor == ThemeManager.shared.currentTheme.value.environment.backgroundColor)")
//        }
//    }
    
    deinit{
        print("Deinited: \(self)")
    }
    
    // MARK: - Init
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup
    internal func setup() {

    }
}

