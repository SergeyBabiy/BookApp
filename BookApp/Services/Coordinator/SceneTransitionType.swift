//
//  SceneTransitionType.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import UIKit

enum SceneTransitionType {
    case root(animated: Bool, animation: UIView.AnimationOptions?)
    case push(animated: Bool)
    case modal(animated: Bool, presentationStyle: UIModalPresentationStyle?)
    case pushToVC(stackPath: [UIViewController], animated: Bool)
    
    case rootTabsSwitching(Int)
}
