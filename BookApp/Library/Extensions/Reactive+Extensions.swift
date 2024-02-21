//
//  Reactive+Extensions.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import Foundation

import RxSwift
import RxCocoa
import WebKit

extension Reactive where Base: UIView {
    
    public var isHiddenWithFade: Binder<(isHidden: Bool, duration: Double)> {
        return Binder(self.base) { view, tuple in
            UIView.animate(withDuration: tuple.duration) {
                view.isHidden = tuple.isHidden
            }
        }
    }
    
    public var isHiddenWithFadeAndBack: Binder<(isHidden: Bool, duration: Double, delay: Double)> {
        return Binder(self.base) { view, tuple in
            UIView.animate(withDuration: tuple.duration,
                           animations: { view.isHidden = tuple.isHidden },
                           completion: {_ in
                            UIView.animate(withDuration: tuple.duration, delay: tuple.delay, options: [], animations: {
                                view.isHidden = !tuple.isHidden
                            })
                        })
            
        }
    }
    
    public var borderColor: Binder<UIColor?> {
        return Binder(self.base) { view, color in
            view.layer.borderColor = color?.cgColor
        }
    }
}

extension Reactive where Base: UITextField {

    public var placeholder: Binder<String?> {
        return Binder(self.base) { textField, text in
            textField.placeholder = text
        }
    }
    
    public var attributedPlaceholder: Binder<NSAttributedString?> {
        return Binder(self.base) { textField, text in
            textField.attributedPlaceholder = text
        }
    }
    
    public var isEditing: Binder<Bool> {
        return Binder(self.base) { textField, isEditing in
            if isEditing {
                textField.becomeFirstResponder()
            } else {
                textField.endEditing(true)
            }
        }
    }
    
    public var textColor: Binder<UIColor?> {
        return Binder(self.base) { textField, color in
            textField.textColor = color
        }
    }
}

extension Reactive where Base: UILabel {
    public var textColor: Binder<UIColor?> {
        return Binder(self.base) { label, color in
            label.textColor = color
        }
    }
}

extension Reactive where Base: UILabel {
    public var font: Binder<UIFont?> {
        return Binder(self.base) { label, font in
            label.font = font
        }
    }
}

extension Reactive where Base: UIRefreshControl {
    public var tintColor: Binder<UIColor?> {
        return Binder(self.base) { refreshControl, color in
            refreshControl.tintColor = color
        }
    }
}

extension Reactive where Base: UITextView {
    public var textColor: Binder<UIColor?> {
        return Binder(self.base) { textView, color in
            textView.textColor = color
        }
    }
}

extension Reactive where Base: UIButton {
    public var titleColor: Binder<UIColor?> {
        return Binder(self.base) { button, color in
            button.setTitleColor(color, for: .normal)
        }
    }
    
    public var tintColor: Binder<UIColor> {
        return Binder(self.base) { button, color in
            button.tintColor = color
        }
    }
}

extension Reactive where Base: UIImageView {
    public var tintColor: Binder<UIColor> {
        return Binder(self.base) { imageView, color in
            imageView.tintColor = color
        }
    }
}

extension Reactive where Base: UINavigationBar {
    public var barTintColor: Binder<UIColor?> {
        return Binder(self.base) { bar, color in
            bar.barTintColor = color
        }
    }
}

extension Reactive where Base: UIRefreshControl {
    public var attributedTitle: Binder<String> {
        return Binder(self.base) { refreshControll, text in
            refreshControll.attributedTitle = NSAttributedString(string: text)
        }
    }
}

extension Reactive where Base: UIScrollView {
    public var contentOffset: Binder<(CGPoint, animated: Bool)> {
        return Binder(self.base) { scrollView, item in
            DispatchQueue.main.async {
                scrollView.setContentOffset(item.0, animated: item.animated)
            }
        }
    }
}

extension Reactive where Base: UITableView {
    public var contentInset: Binder<(UIEdgeInsets, animated: Bool)> {
        return Binder(self.base) { tableView, item in
            DispatchQueue.main.async {
                tableView.contentInset = item.0
            }
        }
    }
}

extension Reactive where Base: CAShapeLayer {
    public var strokeEnd: Binder<CGFloat> {
        return Binder(self.base) { cashLayer, value in
            cashLayer.strokeEnd = value
        }
    }
    
}


extension Reactive where Base: WKWebView {

    var loading: Observable<Bool> {
        return observeWeakly(Bool.self, "loading", options: [.initial, .new]) .map { $0 ?? false }
    }

}
