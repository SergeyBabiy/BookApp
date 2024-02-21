//
//  UIAppliaction+Extension.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import UIKit

extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        //UIApplication.shared.keyWindow?.rootViewController
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
    
    static func topRootViewController() -> UIViewController? {
        UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController?.topMostViewController
    }
}

