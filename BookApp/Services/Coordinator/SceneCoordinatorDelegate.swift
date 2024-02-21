//
//  SceneCoordinatorDelegate.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import RxSwift

protocol SceneCoordinatorDelegate: class {
    var coordinator: SceneCoordinator { get }
    
    func popBack(with animation: Bool) -> Completable
    func popBack(with animation: Bool)
    func popToRoot(with animation: Bool)
}

extension SceneCoordinatorDelegate {
    
    func popBack(with animation: Bool = true) -> Completable {
        return Completable.create {[weak self] (completable) -> Disposable in
            
            _ = self?.coordinator.pop(animated: true)
                                  .ignoreElements()
                                  .subscribe(onError: { completable(.error($0)) }, onCompleted: { completable(.completed) })
            return Disposables.create()
        }
    }

    func popBack(with animation: Bool) {
        coordinator.pop(animated: animation)
    }
    
    func popToRoot(with animation: Bool) {
        coordinator.popToRoot(animated: animation)
    }
}

