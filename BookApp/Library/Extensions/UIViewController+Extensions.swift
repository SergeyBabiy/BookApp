//
//  UIViewController+Extensions.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    func showPreloader() {

        let view = UIView()
        view.frame = CGRect(x: (self.view.frame.width - 128) / 2, y: self.view.frame.height / 1.5, width: 128, height: 128)
        view.tag = 999
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: view, animated: true)
        }

        self.view.addSubview(view)
    }

    func showPreloader(title: String) {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = title
        }

    }

    func hidePreloader() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)

            if let view = self.view.viewWithTag(999) {
                MBProgressHUD.hide(for: view, animated: true)
                view.removeFromSuperview()
            }
        }
    }

    func hideMBHUDPreloader() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }

//    var theme: Theme {
//        return ThemeManager.shared.theme
//    }

    var previousViewController:UIViewController?{
        if let controllersOnNavStack = self.navigationController?.viewControllers, controllersOnNavStack.count >= 2 {
            let n = controllersOnNavStack.count
            return controllersOnNavStack[n - 2]
        }
        return nil
    }

    func hidenTabBar() {
        DispatchQueue.main.async {
            guard var frame = self.tabBarController?.tabBar.frame else { return }

            frame.origin.y = UIScreen.main.bounds.height + (frame.size.height)
            UIView.animate(withDuration: 0.5, animations: {
                self.tabBarController?.tabBar.frame = frame
            })
        }

    }

    func shownTabBar() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            guard var frame = self.tabBarController?.tabBar.frame else { return }

            frame.origin.y = UIScreen.main.bounds.height - (frame.size.height)
            UIView.animate(withDuration: 0.5, animations: {
                self.tabBarController?.tabBar.frame = frame
            })
        }
    }

    func showTabBar(){
        self.tabBarController?.tabBar.isHidden = false
    }

    func hideTabBar(){
        self.tabBarController?.tabBar.isHidden = true
    }

    func showNavBar(){
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func hideNavBar(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
    }

    func removeUnderLineAtNavBar(){
        for parent in self.navigationController?.navigationBar.subviews ?? [] {
            for childView in parent.subviews {
                if(childView is UIImageView) {
                    childView.removeFromSuperview()
                }
            }
        }
    }

    func displayViewController(view: UIView, content: UIViewController, handler: (()->Void)? = nil) {
        self.addChild(content)
        view.addSubview(content.view)
        content.didMove(toParent: self)
        UIView.animate(withDuration: 0.3, animations: {
            content.view.alpha = 1
        }){ _ in
            handler?()
        }
    }

    func hideViewController(content: UIViewController, duration: Double = 0.3, handler: (()->Void)? = nil) {
        UIView.animate(withDuration: TimeInterval(duration), animations: {
            content.view.alpha = 0
        }){_ in
            content.willMove(toParent: nil)
            content.view.removeFromSuperview()
            content.removeFromParent()
            handler?()
        }
    }

    func addKeyboardCheckStateForSuperScroll(){
        NotificationCenter.default.addObserver(self,
                                            selector: #selector(keyboardWillShow),
                                            name: UIResponder.keyboardWillShowNotification,
                                            object: nil)
        NotificationCenter.default.addObserver(self,
                                            selector: #selector(keyboardWillHide),
                                            name: UIResponder.keyboardWillHideNotification,
                                            object: nil)
    }

    func removeKeyboardCheckStateForSuperScroll(){
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            for _view in view.subviews{
                if let scrollView = _view as? UIScrollView{
                    scrollView.setContentOffset(CGPoint(x: 0, y: keyboardSize.height - 100), animated: true)
                    view.layoutIfNeeded()
                    return
                }
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        for _view in view.subviews{
            if let scrollView = _view as? UIScrollView{
                scrollView.setContentOffset(.zero, animated: true)
                view.layoutIfNeeded()
                return
            }
        }
    }

    func displayViewController(content: UIViewController, duration: Double = 0.3, handler: (()->Void)? = nil) {
        UIView.animate(withDuration: TimeInterval(duration), animations: {
            content.view.alpha = 1
        }){[unowned self] _ in
            self.addChild(content)
            self.view.addSubview(content.view)
            content.didMove(toParent: self)
            handler?()
        }
    }

    func removeViewController(content: UIViewController, duration: Double = 0.3, handler: (()->Void)? = nil) {
        UIView.animate(withDuration: TimeInterval(duration), animations: {
            content.view.alpha = 0
        }){ _ in
            content.removeFromParent()
        }
    }

    var isModal: Bool {

        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController

        return presentingIsModal || presentingIsNavigation || presentingIsTabBar || false
    }
    
    var topMostViewController: UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController
        }

        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController ?? navigation
        }

        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController ?? tab
        }

        return self
    }
    
    func showOkAlert(message: String) {
        let alert = UIAlertController(title: "FixarioTech🔧", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

