//
//  UIScrollView+Extension.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import Foundation
import UIKit

extension UIScrollView {

    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToLabel(view: UILabel, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y - 150,width: 1,height: self.frame.height), animated: animated)
        }
    }

    func scrollToViews(view: UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y - 150,width: 1,height: self.frame.height), animated: animated)
        }
    }

    func scrollToView(view: UITextField, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y - 150,width: 1,height: self.frame.height), animated: animated)
        }
    }

    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: contentOffset.x, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }

//    // Bonus: Scroll to bottom
//    func scrollToBottom(animated: Bool = true) {
//        let bottomOffset = CGPoint(x: contentOffset.x, y: contentSize.height - bounds.size.height + contentInset.bottom)
//        if(bottomOffset.y > 0) {
//            setContentOffset(bottomOffset, animated: animated)
//        }
//    }
}


