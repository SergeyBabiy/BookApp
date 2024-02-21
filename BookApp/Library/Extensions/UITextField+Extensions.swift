//
//  UITextField+Extensions.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import UIKit
import RxSwift

extension UITextField {
    
    func setLeftPadding(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPadding(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setIcon(_ image: UIImage, withColor color: UIColor = #colorLiteral(red: 0.1764705882, green: 0.2392156863, blue: 0.3019607843, alpha: 1), with size: CGSize = .init(width: 30, height: 30)) {
        let iconView = UIImageView(frame: CGRect(x: -5, y: 5, width: size.width - 10, height: size.height - 10))
        iconView.image = image
        iconView.contentMode = .scaleAspectFit
        let iconContainerView: UIView = UIView(frame: CGRect(origin: .zero, size: size))
        iconContainerView.addSubview(iconView)
        rightView = iconContainerView
        rightView?.tintColor = color
        rightViewMode = .always
    }
    
    func controlEvent(_ event: UIControl.Event, by diposed: DisposeBag, compl: @escaping () -> Void) {
        self.rx.controlEvent(event)
        .subscribe(onNext: { compl() })
        .disposed(by: diposed)
    }
    
    func controlEventWithDelay(_ event: UIControl.Event, by diposed: DisposeBag, delay: RxTimeInterval = .milliseconds(800) , compl: @escaping () -> Void) {
        self.rx.controlEvent(event)
            .throttle(delay, scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { compl() })
            .disposed(by: diposed)
    }
    
}

