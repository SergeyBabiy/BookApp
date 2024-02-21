//
//  SceneCoordinatorType.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import UIKit
import RxSwift

protocol SceneCoordinatorType {
    init(window: UIWindow)
    
    var currentViewController: UIViewController { get }
    
    @discardableResult
    func transition(to Scene: Scene, type: SceneTransitionType) -> Observable<Void>
    
    @discardableResult
    func pop(animated: Bool) -> Observable<Void>
    
    @discardableResult
    func popToRoot(animated: Bool) -> Observable<Void>
    
    @discardableResult
    func popToVC(_ viewController: UIViewController, animated: Bool) -> Observable<Void>
    
    
}
