//
//  UIView+Extensions.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import UIKit
import SnapKit
import RxSwift
import RxGesture

fileprivate let spinerViewTag = 129404

protocol UIViewElementsActions{
    func addElementsToSuperView()
    func removeElementsFromSuperView()
}

enum LottieAnimation: String {
    case loadingWithDone = "loadingWithDone"
    case loading = "laoding"
}

extension UIView {
    
    func changeBorderColor(toColor: UIColor,  with duration: Double = 1, complete: (()->Void)? = nil) {
        let mainColor = layer.borderColor
        
        let color = CABasicAnimation(keyPath: "borderColor")
        color.fromValue = mainColor
        color.toValue = toColor.cgColor
        color.duration = duration
        color.repeatCount = 1
        color.autoreverses = true
        layer.add(color, forKey: "color and width")
    }
    
    func showModalWithAnimation(duration: Double = 1.2, delay: Double = 0.15, color: UIColor = #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 0.5)) {
        backgroundColor = .clear
        
        UIView.animateKeyframes(withDuration: duration, delay: delay, options: .allowUserInteraction, animations: { [weak self] in
            self?.backgroundColor = color
        })
    }

    func dismissModalWithAnimation(duration: Double = 0.3, completion: @escaping (()->()) = {}) {
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: .allowUserInteraction, animations: { [weak self] in
            self?.backgroundColor = .clear
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            completion()
        }
        
    }

    func dismissModalWithAnimation(duration: Double = 0.3) -> Completable {
        return Completable.create { (completable) -> Disposable in
            UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: .allowUserInteraction, animations: { [weak self] in
                self?.backgroundColor = .clear
            }, completion: {_ in completable(.completed) })

            return Disposables.create()
        }
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-15.0, 15.0, -15.0, 15.0, -8.0, 8.0, -4.0, 4.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    func animateRotation(duration: Int = 5, repeatCount: Float = Float.infinity) {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        rotation.duration = CFTimeInterval(duration)
        rotation.repeatCount = repeatCount
        layer.add(rotation, forKey: "Spin")
    }
    
    
//    func enablePulseEffect(backgroundColor: UIColor, numberOfWaves: Int = 2) {
//        disablePulseEffect()
//        
//        var duration: Double = 0
//        for _ in 0..<numberOfWaves {
//            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {[weak self] in
//                guard let `self` = self else { return }
//                
//                let pulse = PulseAnimation(numberOfPulse: Float.infinity,
//                                           radius: 100,
//                                           cornerRadius: self.layer.cornerRadius,
//                                           postion: .init(x: self.frame.width / 2, y: self.frame.height / 2),
//                                           size: self.frame.size)
//                pulse.animationDuration = 2.0
//                pulse.backgroundColor = backgroundColor.cgColor
//                pulse.zPosition = 0
//                
//                
//                self.layer.addSublayer(pulse)// insertSublayer(pulse, below: self.layer)
//                
//            }
//            
//            duration += 0.5
//        }
//    }
//    
//    func disablePulseEffect() {
//        self.layer.sublayers?.filter{ $0.isKind(of: PulseAnimation.self) }.forEach{ $0.removeAllAnimations() }
//    }
    
    func bindTapGest(with disposeBag: DisposeBag, completion: @escaping () -> ()) {
        rx.tapGesture().when(.recognized)
        .subscribe(onNext: { _ in
            completion()
        })
        .disposed(by: disposeBag)
    }
    
    func bindTapGest(with disposeBag: DisposeBag, completion: @escaping (UITapGestureRecognizer) -> ()) {
         rx.tapGesture().when(.recognized)
         .subscribe(onNext: { gest in
             completion(gest)
         })
         .disposed(by: disposeBag)
     }
    
    
   class func fromNib<T: UIView>() -> T? {
        guard Bundle.main.path(forResource: "\(T.self)", ofType: "nib") != nil else { return nil }
    
        let ss = Bundle(for: T.self).loadNibNamed("\(T.self)", owner: nil, options: nil)?[0] as? T
        return ss
    }

    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }

    func addShadow2(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        var shadows = UIView()
        shadows.frame = self.frame
        shadows.clipsToBounds = false

        addSubview(shadows)

        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 10)
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = color.cgColor
        layer0.shadowOpacity = opacity
        layer0.shadowRadius = radius
        layer0.shadowOffset = offset
        layer0.bounds = shadows.bounds
        layer0.position = shadows.center
        shadows.layer.addSublayer(layer0)
        
        var shapes = UIView()
        shapes.frame = self.frame
        shapes.clipsToBounds = true
        addSubview(shapes)

        let layer1 = CALayer()
        layer1.backgroundColor = color.cgColor
        layer1.bounds = shapes.bounds
        layer1.position = shapes.center
        shapes.layer.addSublayer(layer1)
    }
    
    func changeBackgroundColorAndBack(toColor: UIColor,  with duration: Double = 0.3, complete: (()->Void)? = nil) {
        let mainColor = self.backgroundColor

         UIView.animate(withDuration: duration, animations: { [weak self] in
                   self?.backgroundColor = toColor
               }, completion: { _ in
                    UIView.animate(withDuration: duration, animations: { [weak self] in
                        self?.backgroundColor = mainColor
                    }, completion: { _ in
                        complete?()
                    })
               })
    }
    
    func forceShowSpinner(spinnerStyle: UIActivityIndicatorView.Style = .white){
        guard let spiner = ( subviews.first{ $0.tag == spinerViewTag } ) else {
            showSpinner(spinnerStyle: spinnerStyle)
            return
        }
        spiner.removeFromSuperview()
        showSpinner(spinnerStyle: spinnerStyle)
    }
    
    func showSpinner(spinnerStyle: UIActivityIndicatorView.Style = .whiteLarge){
        
        guard ( subviews.first{ $0.tag == spinerViewTag } ) == nil else { return }
        
        let loadIndicator = UIActivityIndicatorView.init(style: spinnerStyle)
        loadIndicator.tag = spinerViewTag
        loadIndicator.startAnimating()
        
        (self as? UIButton)?.setTitle((self as? UIButton)?.currentTitle, for: .reserved)
        (self as? UIButton)?.setTitle(nil, for: .normal)
        
        (self as? UIButton)?.setImage((self as? UIButton)?.currentImage, for: .reserved)
        (self as? UIButton)?.setImage(nil, for: .normal)
        
        addSubview(loadIndicator)
        loadIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        isUserInteractionEnabled = false
        layoutIfNeeded()
    }
    
    func hideSpinner(){
        guard let spinerView = ( subviews.first{ $0.tag == spinerViewTag } ) else { return }
        
        isUserInteractionEnabled = true
        spinerView.toAlpha(0){
            spinerView.removeFromSuperview()
        }
        
        (self as? UIButton)?.setTitle((self as? UIButton)?.title(for: .reserved), for: .normal)
        (self as? UIButton)?.setTitle(nil, for: .reserved)
        
        (self as? UIButton)?.setImage((self as? UIButton)?.image(for: .reserved), for: .normal)
        (self as? UIButton)?.setImage(nil, for: .reserved)
        layoutIfNeeded()
    }
    
    func toAlpha(_ newAlpha: CGFloat, duration: CGFloat = 0.4, complete: (()->Void)? = nil){
        UIView.animate(withDuration: TimeInterval(duration),
                       animations: {[unowned self] in self.alpha = newAlpha },
                       completion: { (_) in complete?() })
        
    }
    
    func layoutIfNeeded(duration: TimeInterval, complete: (()->Void)? = nil){
        UIView.animate(withDuration: duration,
                       animations: {[unowned self] in
                        self.layoutIfNeeded()
            },
                       completion:  {_ in
                        complete?()
        })
    }
    
    func zoom(to coeficient: CGFloat, with duration: TimeInterval = 0.3, complete: (()->Void)? = nil) {
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: UIView.AnimationOptions.curveLinear,
                       animations: {[unowned self] in
                        self.transform = CGAffineTransform(scaleX: coeficient, y: coeficient)
            },
                       completion:  {_ in
                        complete?()
        })
    }
    
    func bindZooming(toCoeficient: CGFloat = 0.9, with disposeBag: DisposeBag) {
        self.rx
            .forceTouchGesture()
            .when(.began, .ended)
            .subscribe(onNext: { action in
                self.zoom(to: action.state == .began ? toCoeficient : 1)
            })
            .disposed(by: disposeBag)
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    // OUTPUT 2
    func dropShadowWithColor(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius

        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    func scaleHeight(){
        var animations = [CABasicAnimation]()
        let heightAnimation = CABasicAnimation(keyPath: "bounds.size")

        heightAnimation.autoreverses = true
        heightAnimation.duration = 1.0
        heightAnimation.fromValue =  [NSValue(cgSize: CGSize(width: self.frame.size.width, height: self.frame.size.height))]
        heightAnimation.toValue = [NSValue(cgSize: CGSize(width: self.frame.size.width, height: 200.0))]
        animations.append(heightAnimation)

       layer.add(heightAnimation, forKey: "bounds.size")
    }
    
    func to(border color: UIColor, with duration: Double = 0.3) {
        UIView.animate(withDuration: duration) {[weak self] in
            self?.layer.borderColor = color.cgColor
        }
    }
    
    func to(background color: UIColor, with duration: Double = 0.3) {
        UIView.animate(withDuration: duration) {[weak self] in
            self?.backgroundColor = color
        }
    }
    
    func imageWithColor(color: UIColor, inputRect: CGRect? = nil) -> UIImage {

        var rect = CGRect(x: 0.0, y: bounds.maxY - 2.0, width:  2.0, height: bounds.height)
        if let rect1 = inputRect {
            rect = rect1
        }
        UIGraphicsBeginImageContext(rect.size)

        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);

        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return image!
    }
    
    private func springAnim(delay: Double = 0, scale: CGFloat = 0.8, animation: @escaping () -> () = {}) {
        UIView.animate(withDuration: 0.3, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.init(scaleX: scale, y: scale)
            animation() })
    }
    
    func performSpringAnimation() {
        springAnim { [weak self] in self?.springAnim(delay: 0.1, scale: 1) }
    }
    
    func subview<T>(of type: T.Type) -> T? {
        return subviews.compactMap { $0 as? T ?? $0.subview(of: type) }.first
    }
    
}

