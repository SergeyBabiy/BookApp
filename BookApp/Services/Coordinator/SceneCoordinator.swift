//
//  SceneCoordinator.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import RxCocoa
import RxSwift
import UIKit

final class SceneCoordinator: SceneCoordinatorType {
    
    fileprivate var window: UIWindow
    fileprivate let disposeBag = DisposeBag()
    
    var currentViewController: UIViewController
    let rootChanged = PublishSubject<Void>()
    let didLaunch = BehaviorRelay<Bool>(value: false)
    
    required init(window: UIWindow) {
        self.window = window
        currentViewController = window.rootViewController!
    }
    
    static func actualViewController(for viewController: UIViewController) -> UIViewController {
        if let navigationController = viewController as? UINavigationController {
            return navigationController.viewControllers.first!
        } else if let tabBarController = viewController as? UITabBarController, let selectedViewController = tabBarController.selectedViewController {
            return SceneCoordinator.actualViewController(for: selectedViewController)
        } else {
            return viewController
        }
    }
    
    func start() {
        ///#Always start screen will have been fake launch screen, it's will be while default data will be update.
            
        ///#After assign root vc we can launch internet reachbillity manager.
//        InternetReachbility.start(with: self)
    }
}

///#TRANSITION methods.
///#TRANSITION methods.
extension SceneCoordinator {
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Observable<Void> {

        let subject = PublishSubject<Void>()
        let viewController = scene.viewController()

        switch type {
        case .root(let animated, let kind):
            currentViewController = SceneCoordinator.actualViewController(for: viewController)
            
            if animated {
                UIView.transition(with: window, duration: 0.3, options: kind ?? [], animations: {[weak self] in
                    self?.window.rootViewController = viewController
                }, completion: {_ in
                    subject.onCompleted()
                    self.rootChanged.onNext(())
                })
            } else {
                window.rootViewController = viewController
                subject.onCompleted()
            }
            
        case .push(let animated):
            guard let navigationController = currentViewController.navigationController else {
                fatalError("Can't push a view controller without a current navigation controller")
            }
            // one-off subscription to be notified when push complete
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            navigationController.pushViewController(viewController, animated: animated)
            currentViewController = SceneCoordinator.actualViewController(for: viewController)

            //print("✅ after push:\(currentViewController.navigationController?.viewControllers)")
        case .modal(let animated, let presentationStyle):

            viewController.modalPresentationStyle = presentationStyle ?? .fullScreen
            
            currentViewController.present(viewController, animated: animated) {
                subject.onCompleted()
            }
            currentViewController = SceneCoordinator.actualViewController(for: viewController)

        case .pushToVC(let stack, let animated):
            guard let navigationController = currentViewController.navigationController else {
                fatalError("Can't push a view controller without a current navigation controller")
            }

            var controllers = navigationController.viewControllers
            stack.forEach { controllers.append($0) }
            controllers.append(viewController)

            // one-off subscription to be notified when push complete
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            navigationController.setViewControllers(controllers, animated: animated)
            currentViewController = SceneCoordinator.actualViewController(for: viewController)

        case .rootTabsSwitching(let index):
            guard var tabVC = currentViewController.tabBarController else {
              fatalError("Can't switch a view controller without a current tab bar controller")
            }

            while tabVC.tabBarController != nil {
              tabVC = tabVC.tabBarController!
            }

            guard let viewController = tabVC.viewControllers?[index] else {
              fatalError("Index not in range of the tab bar controller's view controllers.")
            }

            tabVC.selectedIndex = index
            currentViewController = SceneCoordinator.actualViewController(for: viewController)
            subject.onCompleted()
        }
        return subject.asObservable()
            .take(1)
    }
}

///#POP methods.
extension SceneCoordinator {
    @discardableResult
    func pop(animated: Bool) -> Observable<Void> {
        let subject = PublishSubject<Void>()
        if let navigationController = currentViewController.navigationController, navigationController.viewControllers.count > 1 {
            // navigate up the stack
            // one-off subscription to be notified when pop complete
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .take(1) // To delete if already in return at bottom
                .map { _ in }
                .bind(to: subject)
            //print("✅ before pop:\(currentViewController.navigationController?.viewControllers)")
            guard navigationController.popViewController(animated: animated) != nil else {
                fatalError("can't navigate back from \(currentViewController)")
            }
            currentViewController = SceneCoordinator.actualViewController(for: navigationController.viewControllers.last!)
        } else if let presenter = currentViewController.presentingViewController {
            // dismiss a modal controller
            currentViewController.dismiss(animated: animated) {
                self.currentViewController = SceneCoordinator.actualViewController(for: presenter)
                subject.onCompleted()
            }
        }  else {
            fatalError("Not a modal, no navigation controller: can't navigate back from \(currentViewController)")
        }
    
        return subject.asObservable()
            .take(1)
    }
    
    @discardableResult
    func popToRoot(animated: Bool) -> Observable<Void> {
        
        let subject = PublishSubject<Void>()
        
        if let presenter = currentViewController.presentingViewController {
            // dismiss a modal controller
            currentViewController.dismiss(animated: animated) {
                self.currentViewController = SceneCoordinator.actualViewController(for: presenter)
                subject.onCompleted()
            }
        } else if let navigationController = currentViewController.navigationController {
            // navigate up the stack
            // one-off subscription to be notified when pop complete
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .take(1) // To delete if already in return at bottom
                .map { _ in }
                .bind(to: subject)
            
            guard navigationController.popToRootViewController(animated: animated) != nil else {
                subject.onCompleted()
                return subject.asObservable().take(1)
            }
            
            _ = subject.subscribe(onCompleted: {[weak self] in
                self?.currentViewController = SceneCoordinator.actualViewController(for: navigationController.viewControllers.first!)
            })
        }
        
        return subject.asObservable()
            .take(1)
    }
    
    @discardableResult
    func popToVC(_ viewController: UIViewController, animated: Bool) -> Observable<Void> {
        
        let subject = PublishSubject<Void>()
        
        if let navigationController = currentViewController.navigationController {
            // navigate up the stack
            // one-off subscription to be notified when pop complete
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .take(1) // To delete if already in return at bottom
                .map { _ in }
                .bind(to: subject)
            
            guard navigationController.popToViewController(viewController, animated: animated) != nil else {
                fatalError("can't navigate back to VC from \(currentViewController)")
            }
            currentViewController = SceneCoordinator.actualViewController(for: navigationController.viewControllers.last!)
        }
        return subject.asObservable()
            .take(1)
    }
    
    @discardableResult
    func removeFromStack(_ viewControllerType: UIViewController.Type) -> Observable<Void> {
        
        let subject = PublishSubject<Void>()
        
        if let navigationController = currentViewController.navigationController {
            guard let index = navigationController.viewControllers.firstIndex(where: { $0.isKind(of: viewControllerType)}) else {
                subject.onCompleted()
                return subject.asObservable().take(1)
                ///fatalError("can't navigate back to VC from \(currentViewController)")
            }
            navigationController.viewControllers.remove(at: index)
            subject.onCompleted()
        }
        
        subject.onError(NSError.error("Have not navigation controller."))
        return subject.asObservable().take(1)
    }
   
    @discardableResult
    func forcePopFromCurrentVC() -> Completable {
           if let presenter = currentViewController.presentingViewController  {
               self.currentViewController = SceneCoordinator.actualViewController(for: presenter)
               
           } else if let navigationController = currentViewController.navigationController {
               currentViewController = SceneCoordinator.actualViewController(for: navigationController.viewControllers.last!)
           } else {
               fatalError("Not a modal, no navigation controller: can't navigate back from \(currentViewController)")
           }
           return .empty()
       }
}

///#ROOT Assigns.
extension SceneCoordinator {
//    func changeRootToHome(animated: Bool = true) -> Completable {
//        return Completable.create {[weak self] (completable) -> Disposable in
//            guard let `self` = self else {
//                return Disposables.create()
//            }
//
//            let viewModel = HomeSideMenuViewModel(coordinator: self,
//                                                  localStorageManager: HomeSideMenuLocalStorageManager(),
//                                                  networkManager: HomeSideMenuNetworkManager())
//            let homeScene = Scene.home(HomeViewModel(coordinator: self, networkManager: HomeNetworkManager()))
//
//            let scene = Scene.homeSideMenuScene(viewModel, root: BaseNavigationController(rootViewController: homeScene.viewController()))
//
//            _ = self.transition(to: scene, type: .root(animated: animated, animation: .transitionFlipFromLeft))
//                    .ignoreElements()
//                    .subscribe(onCompleted: { completable(.completed) },
//                               onError: { completable(.error($0)) })
//
//            return Disposables.create()
//        }
//    }

//    func changeRootToAuth(animated: Bool = true) -> Completable {
//        return Completable.create { (completable) -> Disposable in
//            let viewModel = AuthViewModel(coordinator: self, networkManager: AuthNetworkManager())
//            let scene = Scene.auth(viewModel)
//
//            _ = self.transition(to: scene, type: .root(animated: animated, animation: .transitionFlipFromLeft))
//                .ignoreElements()
//                .subscribe(onCompleted: { completable(.completed) },
//                           onError: { completable(.error($0) )})
//
//            return Disposables.create()
//        }
//    }
}
