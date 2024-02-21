//
//  AppDelegate.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import UIKit
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var sceneCoordinator = {
        SceneCoordinator(window: window!)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setIntitialController()
        setupAlertManager()
        return true
    }

   

}

extension AppDelegate {
    
    func setIntitialController(){
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UIViewController()
        
        let scene = Scene.lauchScreen(LaunchUpdateViewModel(coordinator: sceneCoordinator))
        sceneCoordinator.transition(to: scene, type: .root(animated: false, animation: nil))
    }
    
    func setupAlertManager() {
        AlertManager.sceneCoordinator = sceneCoordinator
    }
}

