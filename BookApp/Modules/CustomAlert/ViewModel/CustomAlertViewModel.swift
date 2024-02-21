//
//  CustomAlertViewModel.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import UIKit
import RxSwift
import RxCocoa

protocol CustomAlertViewModelInputs {
    func pop() -> Completable
}

protocol CustomAlertViewModelOutputs {
    var text: String { get }
    var actions: [CustomAlertActionConfig] { get }
}

class CustomAlertViewModel: ViewModelBindings, CustomAlertViewModelInputs, CustomAlertViewModelOutputs, SceneCoordinatorDelegate {
    
    required init(coordinator: SceneCoordinator,
                  text: String,
                  actions: [CustomAlertActionConfig]? = nil) {
        
        self.coordinator = coordinator
        self.text = text
        self.actions = actions ?? []
    }
    
    func pop() -> Completable {
        return Completable.create {[weak self] (completable) -> Disposable in
            _ = self?.coordinator
                .pop(animated: true)
                .ignoreElements()
                .subscribe(onError: { completable(.error($0)) }, onCompleted: { completable(.completed) })
            
            return Disposables.create()
        }
    }

    var text: String
    var actions: [CustomAlertActionConfig]
    
    var error = PublishSubject<Error>()
    
    var coordinator: SceneCoordinator
    
    var inputs:CustomAlertViewModelInputs {self}
    var outputs: CustomAlertViewModelOutputs {self}
}

