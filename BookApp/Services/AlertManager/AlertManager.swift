//
//  AlertManager.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import UIKit
import RxSwift

class AlertManager {
    static var sceneCoordinator: SceneCoordinator?
    
    class func alertOK(title: String?,
                       message: String?,
                       completion: (() -> Void)?) {
        
        guard let sceneCoordinator = sceneCoordinator else { return }
        guard !UIApplication.shared.keyWindow!.rootViewController!.topMostViewController.isKind(of: CustomAlertViewController.self) else {
            return
        }
        
        let ok = CustomAlertActionConfig(action: completion, title: "OK")
        
        let viewModel = CustomAlertViewModel(coordinator: sceneCoordinator,
                                              text: message ?? "",
                                              actions: [ok])
        let scene = Scene.galaxionAlert(viewModel)
        sceneCoordinator.transition(to: scene, type: .modal(animated: true, presentationStyle: .overFullScreen))
    }
    
    class func alertOK(message: String?,
                       completion: (() -> Void)?) -> Completable {
        
        return Completable.create { (completable) -> Disposable in
            
            guard let sceneCoordinator = sceneCoordinator else {
                completable(.error(NSError.error("sceneCoordinator absent.")))
                return Disposables.create()
            }
            guard !UIApplication.shared.keyWindow!.rootViewController!.topMostViewController.isKind(of: CustomAlertViewController.self) else {
                completable(.error(NSError.error("alert already present.")))
                return Disposables.create()
            }
            
            let ok = CustomAlertActionConfig(action: completion, title: "OK")
            
            let viewModel = CustomAlertViewModel(coordinator: sceneCoordinator,
                                                  text: message ?? "",
                                                  actions: [ok])
            let scene = Scene.galaxionAlert(viewModel)
            _ = sceneCoordinator
                .transition(to: scene, type: .modal(animated: true, presentationStyle: .overFullScreen))
                .ignoreElements()
                .subscribe(onError: { completable(.error($0)) }, onCompleted:  { completable(.completed) })
            
            return Disposables.create()
        }
    }
    
    class func alertOK(message: String) -> Completable {
        
        return Completable.create { (completable) -> Disposable in
            
            guard let sceneCoordinator = sceneCoordinator else {
                completable(.error(NSError.error("sceneCoordinator absent.")))
                return Disposables.create()
            }
            guard !UIApplication.shared.keyWindow!.rootViewController!.topMostViewController.isKind(of: CustomAlertViewController.self) else {
                completable(.error(NSError.error("alert already present.")))
                return Disposables.create()
            }
            
            let ok = CustomAlertActionConfig(action: { completable(.completed) }, title: "OK")
            
            let viewModel = CustomAlertViewModel(coordinator: sceneCoordinator,
                                                  text: message ?? "",
                                                  actions: [ok])
            let scene = Scene.galaxionAlert(viewModel)
            _ = sceneCoordinator
                .transition(to: scene, type: .modal(animated: true, presentationStyle: .overFullScreen))
                .subscribe()
            
            return Disposables.create()
        }
    }
    
    class func alertYesNo(title: String?,
                          message: String?,
                          yesCompletion: (() -> Void)?,
                          noCompletion: (() -> Void)?) {
        
        guard let sceneCoordinator = sceneCoordinator else { return }
        
        guard !UIApplication.shared.keyWindow!.rootViewController!.topMostViewController.isKind(of: CustomAlertViewController.self) else {
            return
        }
        
        let yes = CustomAlertActionConfig(action: yesCompletion,
                                           title: "да(не локализированно)")
        
        let no = CustomAlertActionConfig(action: noCompletion,
                                          title: "нет( не локализированно)")
        
        let viewModel = CustomAlertViewModel(coordinator: sceneCoordinator,
                                              text: message ?? "",
                                              actions: [yes, no])
        let scene = Scene.galaxionAlert(viewModel)
        sceneCoordinator.transition(to: scene, type: .modal(animated: true, presentationStyle: .overFullScreen))
    }
    
    class func alertInternetAbsent(completion: (() -> Void)? = nil) {
        guard let sceneCoordinator = sceneCoordinator else { return }
        
        guard !UIApplication.shared.keyWindow!.rootViewController!.topMostViewController.isKind(of: CustomAlertViewController.self) else {
            return
        }
        
        let ok = CustomAlertActionConfig(action: completion, title: "OK")
        
        let viewModel = CustomAlertViewModel(coordinator: sceneCoordinator,
                                              text: InternetReachbilityManager.Error.noConnection,
                                              actions: [ok])
        let scene = Scene.galaxionAlert(viewModel)
        sceneCoordinator.transition(to: scene, type: .modal(animated: true, presentationStyle: .overFullScreen))
    }
    
    class func actionSheet(from: UIViewController,
                           title: String?,
                           message: String?,
                           actions: [UIAlertAction]?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        actions?.forEach{ alert.addAction($0) }
        
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = from.view
            popoverPresentationController.sourceRect = from.view.bounds
            popoverPresentationController.permittedArrowDirections = []
        }
        
        from.present(alert, animated: true, completion: nil)
    }
    
    class func alert(title: String?,
                     message: String?,
                     actions: [CustomAlertActionConfig]?) {
        
        guard let sceneCoordinator = sceneCoordinator else { return }
        
        guard !UIApplication.shared.keyWindow!.rootViewController!.topMostViewController.isKind(of: CustomAlertViewController.self) else {
            return
        }
        
        let viewModel = CustomAlertViewModel(coordinator: sceneCoordinator,
                                              text: message ?? "",
                                              actions: actions)
        let scene = Scene.galaxionAlert(viewModel)
        sceneCoordinator.transition(to: scene, type: .modal(animated: true, presentationStyle: .overFullScreen))
    }
    
    class func quickAlert(title: String?,
                          message: String?,
                          completion: (() -> Void)?) {
        
        guard let sceneCoordinator = sceneCoordinator else { return }
        
        guard !UIApplication.shared.keyWindow!.rootViewController!.topMostViewController.isKind(of: CustomAlertViewController.self) else {
            return
        }
        
        let viewModel = CustomAlertViewModel(coordinator: sceneCoordinator,
                                              text: message ?? "")
        let scene = Scene.galaxionAlert(viewModel)
        
        let escapeComplete = Completable.create(subscribe: { (completable) -> Disposable in
            completion?()
            completable(.completed)
            return Disposables.create()
        })
    }
    
        open class func alertOKCancel(title: String?,
                                      message: String?,
                                      textFieldPlaceholder: String?,
                                      textFieldText: String?,
                                      secureEntry: Bool,
                                      completion: @escaping (String?) -> Void,
                                      cancelCompletion: (() -> Void)?) {
    
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: title,
                                                        message: message,
                                                        preferredStyle: .alert)
    
                var textFieldForClosure: UITextField?
    
                alertController.addTextField(configurationHandler: { (textField) in
                    textField.isSecureTextEntry = secureEntry
                    textField.placeholder = textFieldPlaceholder
                    textField.text = textFieldText
                    textFieldForClosure = textField
                })
    
                let cancelButton = UIAlertAction(title: "Cancel",
                                                 style: .cancel,
                                                 handler: { (action) in
                                                    if let cancelCompletion = cancelCompletion {
                                                        cancelCompletion()
                                                    }
                })
    
                let okButton = UIAlertAction(title: "OK",
                                             style: .default,
                                             handler: { (action) in
                                                completion(textFieldForClosure?.text)
                })
    
                alertController.addAction(cancelButton)
                alertController.addAction(okButton)
                UIApplication.topRootViewController()?.present(alertController, animated: true, completion: nil)
            }
        }
}


//public protocol KRAlerter {
//    func alertOK(title: String?, message: String?, completion: (() -> Void)?)
//
//    func alertOKCancel(title: String?, message: String?, completion: (() -> Void)?)
//
//    func alertYesNo(title: String?,
//                    message: String?,
//                    yesCompletion: (() -> Void)?,
//                    noCompletion: (() -> Void)?)
//
//    func alertError(message: String?, completion: (() -> Void)?)
//
//    func alert(title: String?,
//               message: String?,
//               firstButtonTitle: String?,
//               firstButtonCompletion: (() -> Void)?,
//               secondButtonTitle: String?,
//               secondButtonCompletion: (() -> Void)?)
//
//    func alert(title: String?, message: String?, actions: [UIAlertAction]?)
//
//    func alertOKCancel(title: String?,
//                       message: String?,
//                       textFieldPlaceholder: String?,
//                       textFieldText: String?,
//                       secureEntry: Bool,
//                       completion: @escaping (String?) -> Void,
//                       cancelCompletion: (() -> Void)?)
//
//    func actionSheetPickPhoto(galleryCompletion: @escaping () -> Void,
//                              cameraCompletion: @escaping () -> Void)
//
//    func actionSheet(title: String?,
//                     message: String?,
//                     firstButtonTitle: String?,
//                     firstButtonCompletion: (() -> Void)?,
//                     secondButtonTitle: String?,
//                     secondButtonCompletion: (() -> Void)?)
//
//    func actionSheet(title: String?, message: String?, actions: [UIAlertAction]?)
//}
//
//public extension KRAlerter where Self: UIViewController {
//
//    // MARK: - Alerts
//
//    func alertOK(title: String?, message: String?, completion: (() -> Void)?) {
//        AlertManager.alertOK(title: title, message: message, completion: completion)
//    }
//
//    func alertOKCancel(title: String?, message: String?, completion: (() -> Void)?) {
//        AlertManager.alertOKCancel(title: title, message: message, completion: completion)
//    }
//
//    func alertYesNo(title: String?,
//                    message: String?,
//                    yesCompletion: (() -> Void)?,
//                    noCompletion:(() -> Void)?) {
//
//        AlertManager.alertYesNo(title: title,
//                           message: message,
//                           yesCompletion: yesCompletion,
//                           noCompletion: noCompletion)
//
//    }
//
//    func alertError(message: String?, completion: (() -> Void)?) {
//        AlertManager.alertError(message: message, completion: completion)
//    }
//
//    func alert(title: String?,
//               message: String?,
//               firstButtonTitle: String?,
//               firstButtonCompletion: (() -> Void)?,
//               secondButtonTitle: String?,
//               secondButtonCompletion: (() -> Void)?) {
//
//        AlertManager.alert(title: title,
//                      message: message,
//                      firstButtonTitle: firstButtonTitle,
//                      firstButtonCompletion: firstButtonCompletion,
//                      secondButtonTitle: secondButtonTitle,
//                      secondButtonCompletion: secondButtonCompletion)
//
//    }
//
//    func alert(title: String?, message: String?, actions: [UIAlertAction]?) {
//        AlertManager.alert(title: title, message: message, actions: actions)
//    }
//
//    func alertOKCancel(title: String?,
//                       message: String?,
//                       textFieldPlaceholder: String?,
//                       textFieldText: String?,
//                       secureEntry: Bool,
//                       completion: @escaping (String?) -> Void,
//                       cancelCompletion: (() -> Void)?) {
//
//        AlertManager.alertOKCancel(title: title,
//                              message: message,
//                              textFieldPlaceholder: textFieldPlaceholder,
//                              textFieldText: textFieldText,
//                              secureEntry: secureEntry,
//                              completion: completion,
//                              cancelCompletion: cancelCompletion)
//
//    }
//
//    // MARK: - Action Sheets
//
//    func actionSheetPickPhoto(galleryCompletion: @escaping () -> Void,
//                              cameraCompletion: @escaping () -> Void) {
//
//        AlertManager.actionSheetPickPhoto(galleryCompletion: galleryCompletion,
//                                          cameraCompletion: cameraCompletion)
//
//    }
//
//    func actionSheet(title: String?,
//                     message: String?,
//                     firstButtonTitle: String?,
//                     firstButtonCompletion: (() -> Void)?,
//                     secondButtonTitle: String?,
//                     secondButtonCompletion: (() -> Void)?) {
//
//        AlertManager.actionSheet(title: title,
//                                message: message,
//                                firstButtonTitle: firstButtonTitle,
//                                firstButtonCompletion: firstButtonCompletion,
//                                secondButtonTitle: secondButtonTitle,
//                                secondButtonCompletion: secondButtonCompletion)
//
//    }
//
//    func actionSheet(title: String?, message: String?, actions: [UIAlertAction]?) {
//        AlertManager.actionSheet(from: self, title: title, message: message, actions: actions)
//    }
//
//}
//
//public class AlertManager {
//
//    public static var okButtonTitle = "OK"
//    public static var cancelButtonTitle = "Cancel"
//    public static var yesButtonTitle = "Yes"
//    public static var noButtonTitle = "No"
//    public static var alertErrorTitle = "Error"
//    public static var pickPhotoTitle  = "Pick Photo"
//    public static var pickPhotoMessage  = "Choose source"
//    public static var pickPhotoGalleryButtonTitle  = "From gallery"
//    public static var pickPhotoCameraButtonTitle  = "From camera"
//
//
//    // MARK: - Alerts
//    open class func alertOK(title: String?,
//                            message: String?,
//                            completion: (() -> Void)?) {
//
//        alert(title: title,
//              message: message,
//              firstButtonTitle: okButtonTitle,
//              firstButtonCompletion: completion,
//              secondButtonTitle: nil,
//              secondButtonCompletion: nil)
//
//    }
//
//    open class func alertInternetAbsent(completion: (() -> Void)? = nil) {
//
//        alert(title: InternetReachbilityManager.Error.noConnectionTitle,
//              message: InternetReachbilityManager.Error.noConnection,
//              firstButtonTitle: okButtonTitle,
//              firstButtonCompletion: completion,
//              secondButtonTitle: nil,
//              secondButtonCompletion: nil)
//
//    }
//
//    open class func alertOKCancel(title: String?,
//                                  message: String?,
//                                  completion: (() -> Void)?) {
//
//        alert(title: title,
//              message: message,
//              firstButtonTitle: cancelButtonTitle,
//              firstButtonCompletion: nil,
//              secondButtonTitle: okButtonTitle,
//              secondButtonCompletion: completion)
//
//    }
//
//    open class func alertYesNo(title: String?,
//                               message: String?,
//                               yesCompletion: (() -> Void)?,
//                               noCompletion: (() -> Void)?) {
//
//        alert(title: title,
//              message: message,
//              firstButtonTitle: noButtonTitle,
//              firstButtonCompletion: noCompletion,
//              secondButtonTitle: yesButtonTitle,
//              secondButtonCompletion: yesCompletion)
//
//    }
//
//    open class func alertError(message: String?,
//                               completion:(() -> Void)?) {
//
//        alertOK(title: alertErrorTitle,
//                message: message,
//                completion: completion)
//
//    }
//
//    open class func alert(title: String?,
//                          message: String?,
//                          firstButtonTitle: String?,
//                          firstButtonCompletion: (() -> Void)?,
//                          secondButtonTitle: String?,
//                          secondButtonCompletion: (() -> Void)?) {
//
//        var actions: [UIAlertAction] = []
//
//        actions.append(UIAlertAction(title: firstButtonTitle,
//                                     style: .cancel,
//                                     handler: { (action) in
//                                        if let firstButtonCompletion = firstButtonCompletion {
//                                            firstButtonCompletion()
//                                        }
//        }))
//
//        if let secondButtonTitle = secondButtonTitle {
//            actions.append(UIAlertAction(title: secondButtonTitle,
//                                         style: .default,
//                                         handler: { (action) in
//                                            if let secondButtonCompletion = secondButtonCompletion {
//                                                secondButtonCompletion()
//                                            }
//            }))
//        }
//        alert(title: title, message: message, actions: actions)
//    }
//
//    open class func alert(title: String?,
//                          message: String?,
//                          actions: [UIAlertAction]?) {
//        abstractAlert(title: title,
//                      message: message,
//                      style: .alert,
//                      actions: actions)
//    }
//
//
//    open class func quickAlert(title: String?,
//                               message: String?,
//                               duration: Double = 1.3, completion: @escaping () -> () = {}) {
//
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//
//        UIApplication.topRootViewController()?.present(alertController, animated: true, completion: nil)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
//            alertController.dismiss(animated: true, completion: completion)
//        }
//
//    }
//
//
//
//
//    // MARK: - Alert with UITextField
//
//    open class func alertOKCancel(title: String?,
//                                  message: String?,
//                                  textFieldPlaceholder: String?,
//                                  textFieldText: String?,
//                                  secureEntry: Bool,
//                                  completion: @escaping (String?) -> Void,
//                                  cancelCompletion: (() -> Void)?) {
//
//        DispatchQueue.main.async {
//            let alertController = UIAlertController(title: title,
//                                                    message: message,
//                                                    preferredStyle: .alert)
//
//            var textFieldForClosure: UITextField?
//
//            alertController.addTextField(configurationHandler: { (textField) in
//                textField.isSecureTextEntry = secureEntry
//                textField.placeholder = textFieldPlaceholder
//                textField.text = textFieldText
//                textFieldForClosure = textField
//            })
//
//            let cancelButton = UIAlertAction(title: cancelButtonTitle,
//                                             style: .cancel,
//                                             handler: { (action) in
//                                                if let cancelCompletion = cancelCompletion {
//                                                    cancelCompletion()
//                                                }
//            })
//
//            let okButton = UIAlertAction(title: okButtonTitle,
//                                         style: .default,
//                                         handler: { (action) in
//                                            completion(textFieldForClosure?.text)
//            })
//
//            alertController.addAction(cancelButton)
//            alertController.addAction(okButton)
//            UIApplication.topRootViewController()?.present(alertController, animated: true, completion: nil)
//        }
//    }
//
//    // MARK: - Action Sheet
//
//    open class func actionSheetPickPhoto(galleryCompletion: @escaping () -> Void,
//                                         cameraCompletion: @escaping () -> Void) {
//        actionSheet(title: pickPhotoTitle,
//                    message: pickPhotoMessage,
//                    firstButtonTitle: pickPhotoGalleryButtonTitle,
//                    firstButtonCompletion: galleryCompletion,
//                    secondButtonTitle: pickPhotoCameraButtonTitle,
//                    secondButtonCompletion: cameraCompletion)
//
//    }
//
//    open class func actionSheet(title: String?,
//                                message: String?,
//                                firstButtonTitle: String?,
//                                firstButtonCompletion: (() -> Void)?,
//                                secondButtonTitle: String?,
//                                secondButtonCompletion: (() -> Void)?) {
//
//        var actions: [UIAlertAction] = []
//
//        actions.append(UIAlertAction(title: firstButtonTitle,
//                                     style: .default,
//                                     handler: { (action) in
//                                        if let firstButtonCompletion = firstButtonCompletion {
//                                            firstButtonCompletion()
//                                        }
//        }))
//
//        if let secondButtonTitle = secondButtonTitle {
//            actions.append(UIAlertAction(title: secondButtonTitle,
//                                         style: .default,
//                                         handler: { (action) in
//                                            if let secondButtonCompletion = secondButtonCompletion {
//                                                secondButtonCompletion()
//                                            }
//            }))
//        }
//
//        actions.append(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil))
//
//        abstractAlert(title: title,
//                      message: message,
//                      style: .actionSheet,
//                      actions: actions)
//
//    }
//
//    open class func actionSheet(from viewController: UIViewController,
//                                title: String?,
//                                message: String?,
//                                actions: [UIAlertAction]?) {
//
//        abstractAlert(title: title,
//                      message: message,
//                      style: .actionSheet,
//                      actions: actions)
//
//    }
//
//    // MARK: - Abstract
//
//    public class func abstractAlert(title: String?,
//                                    message: String?,
//                                    style: UIAlertController.Style,
//                                    actions: [UIAlertAction]?) {
//        DispatchQueue.main.async {
//            let alertController = self.alertController(title: title,
//                                                       message: message,
//                                                       style: style,
//                                                       actions: actions)
//            UIApplication.topRootViewController()?.present(alertController, animated: true, completion: nil)
//        }
//    }
//
//    public class func alertController(title: String?,
//                                      message: String?,
//                                      style: UIAlertController.Style,
//                                      actions: [UIAlertAction]?) -> UIAlertController {
//        let alertController = UIAlertController(title: title,
//                                                message: message,
//                                                preferredStyle: style)
//
//        if let actions = actions {
//            for action in actions {
//                alertController.addAction(action)
//            }
//        }
//        return alertController
//    }
//}

