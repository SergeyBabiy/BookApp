//
//  BaseAlertActionConfig.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import UIKit

class CustomAlertActionConfig {
    var action: (()->Void)?
    var title: String
    var backgroundColor: UIColor
    var textColor: UIColor
    
    init (action: (()->Void)?,
          title: String,
          backgroundColor: UIColor = .purple,
          textColor: UIColor = .white) {
        
        self.action = action
        self.title = title
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }
    
    static var ok: CustomAlertActionConfig {
        CustomAlertActionConfig(action: nil,
                                title: "OK",
                                backgroundColor: .purple,
                                textColor: .white)
    }
}
