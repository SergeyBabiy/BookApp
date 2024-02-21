//
//  DebugViewModel.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import RxSwift
import RxCocoa

protocol DebugViewModelInputs {
    func selectedScene(scene: DebugScene) -> Completable
}

protocol DebugViewModelOutputs {
    var scenes: BehaviorRelay<[DebugScene]> { get }
}

class DebugViewModel: ViewModelBindings, DebugViewModelInputs, SceneCoordinatorDelegate, DebugViewModelOutputs {
    
    init(coordinator: SceneCoordinator) {
        self.coordinator = coordinator
    }
    
    func selectedScene(scene: DebugScene) -> Completable {
        switch scene {
        case .home:
            return homeScene()
        case .test:
            return testViewScene()
        }
    }
    
    func homeScene() -> Completable {
        return Completable.create { (completable) -> Disposable in
            let viewModel = HomeViewModel(coordinator: self.coordinator)
            _ = self.coordinator.transition(to: .home(viewModel), type: .root(animated: true, animation: nil))
                .subscribe(onCompleted: { completable(.completed) })
            return Disposables.create()
        }
    }
    
    func testViewScene() -> Completable {
        return Completable.create { (completable) -> Disposable in
            let viewModel = TestViewModel(coordinator: self.coordinator)
            _ = self.coordinator.transition(to: .testView(viewModel), type: .push(animated: true))
                .subscribe(onCompleted: { completable(.completed) })
            return Disposables.create()
        }
    }

    let scenes: BehaviorRelay<[DebugScene]> = BehaviorRelay(value: DebugScene.allCases)
    
    let coordinator: SceneCoordinator
    let error: PublishSubject<Error> = PublishSubject()
    let disposeBag = DisposeBag()
    var inputs: DebugViewModelInputs { self }
    var outputs: DebugViewModelOutputs { self }
}
