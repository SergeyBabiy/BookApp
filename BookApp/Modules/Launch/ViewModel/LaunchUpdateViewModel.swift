//
//  LaunchUpdateViewModel.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import RxSwift
import RxCocoa

protocol LaunchUpdateManagerViewModelProtocol: LaunchUpdateManagerViewModelInputs, LaunchUpdateManagerViewModelOutputs {
}

protocol LaunchUpdateManagerViewModelInputs {
    func update()
}

protocol LaunchUpdateManagerViewModelOutputs {
    
}

class LaunchUpdateViewModel: ViewModelBindings, SceneCoordinatorDelegate, LaunchUpdateManagerViewModelProtocol {
    deinit {
        print("Deinit:\(self). DisposeBag:\(disposeBag)")
    }
    
    static private(set)var didFinished = BehaviorRelay<Bool>(value: false)
    
    let debugMode = true
    var methodsForStartUploaded = false
    
    init(coordinator: SceneCoordinator) {
        self.coordinator = coordinator
    }
    
    static func waitForDidLaunch() -> Completable {
        return Completable.create { (completable) -> Disposable in
            _ = LaunchUpdateViewModel.didFinished
                .filter{ $0 }
                .take(1)
                .subscribe(onNext: {_ in completable(.completed) })
            
            return Disposables.create()
        }
    }
    
    func changeRootToHome() -> Completable {
        return Completable.create { (completable) -> Disposable in
            LaunchUpdateViewModel.didFinished.accept(true)
            let viewModel = HomeViewModel(coordinator: self.coordinator)
            _ = self.coordinator.transition(to: .home(viewModel), type: .root(animated: true, animation: nil))
                .subscribe(onCompleted: { completable(.completed) })
            
            return Disposables.create()
        }
    }
    
    
    
    //    func redirectToOnboarding() -> Completable {
    //        return Completable.create { (completable) -> Disposable in
    //            let viewModel = OnboardingViewModel(coordinator: self.coordinator)
    //            let scene = Scene.onboardingScene(viewModel)
    //            _ = self.coordinator.transition(to: scene, type: .root(animated: false, animation: .curveEaseIn))
    //                .ignoreElements()
    //                .subscribe(onCompleted: { completable(.completed) },
    //                           onError: { completable(.error($0)) })
    //
    //            return Disposables.create()
    //        }
    //    }
    
    
    func enableDebugMode() -> Completable {
        return Completable.create { (completable) -> Disposable in
            let viewModel = DebugViewModel(coordinator: self.coordinator)
            let scene = Scene.debug(viewModel)
            
            _ = self.coordinator
                .transition(to: scene, type: .root(animated: false, animation: nil))
                .ignoreElements()
                .subscribe(onError: { completable(.error($0)) }, onCompleted: { completable(.completed) })
            return Disposables.create()
        }
    }
    
    func waitToModeDisable() -> Completable {
        return Completable.create {[weak self] (completable) -> Disposable in
            guard let `self` = self else {
                completable(.error(NSError.error("Deinited.")))
                return Disposables.create()
            }
            
            self.toExceptionObserver?.dispose()
            
            var requestObserver: Disposable?
            
            self.toExceptionObserver = Observable<Int>
                .interval(.seconds(7), scheduler: MainScheduler.asyncInstance)
                .subscribe(onNext: {_ in
                    requestObserver?.dispose()
                    //                    requestObserver = SettingsManager.checkReadiness()
                    //                            .subscribe(onCompleted: { completable(.completed) })
                })
            
            return Disposables.create()
        }
    }
    
    func revokeListenerOfToModeDisable() -> Completable {
        return Completable.create {[weak self] (completable) -> Disposable in
            self?.toExceptionObserver?.dispose()
            completable(.completed)
            return Disposables.create()
        }
    }
    
    private func redirectTo(scene: Scene) -> Completable {
        return Completable.create { (completable) -> Disposable in
            _ = self.coordinator.transition(to: scene, type: .root(animated: false, animation: .curveEaseIn))
                .ignoreElements()
                .subscribe(onError: { completable(.error($0) )}, onCompleted: { completable(.completed) })
            return Disposables.create()
        }
    }
    
    func update() {
        if debugMode {
            start()
                .andThen(enableDebugMode())
                .subscribe()
                .disposed(by: disposeBag)
        } else {
            start()
                .andThen(changeRootToHome())
                .subscribe()
                .disposed(by: disposeBag)
        }
    }
    
    func start() -> Completable {
        return Completable.create {  (completable) -> Disposable in
            //let settingsService = self.settinsService()
            let arrayCompletables: [Completable] = []
            Completable.zip(arrayCompletables)
                .andThen(self.markThatMethodsForStartReady())
                .subscribe(onCompleted: { completable(.completed) },
                           onError: { completable(.error($0)) })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    func markThatMethodsForStartReady() -> Completable {
        return Completable.create {[weak self] (completable) -> Disposable in
            self?.methodsForStartUploaded = true
            completable(.completed)
            return Disposables.create()
        }
    }
    
    static let launchUpdateSignal = PublishSubject<Void>()
    private var internetObserver: Disposable?
    private var toExceptionObserver: Disposable?
    
    let coordinator: SceneCoordinator
    let error: PublishSubject<Error> = PublishSubject()
    let disposeBag = DisposeBag()
    var inputs: LaunchUpdateManagerViewModelInputs { self }
    var outputs: LaunchUpdateManagerViewModelOutputs { self }
}

