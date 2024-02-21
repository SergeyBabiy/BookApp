//
//  TestViewModel.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import RxSwift
import RxCocoa

protocol TestViewModelInputs {
}

protocol TestViewModelOutputs {
}

class TestViewModel: ViewModelBindings, TestViewModelInputs, SceneCoordinatorDelegate, TestViewModelOutputs {
    
    init(coordinator: SceneCoordinator) {
        self.coordinator = coordinator
    }
    
    let coordinator: SceneCoordinator
    let error: PublishSubject<Error> = PublishSubject()
    let disposeBag = DisposeBag()
    var inputs: TestViewModelInputs { self }
    var outputs: TestViewModelOutputs { self }
}
