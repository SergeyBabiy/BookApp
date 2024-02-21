//
//  BaseViewController.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController<ViewType: View>: UIViewController where ViewType: ViewModelConfigurable {
    typealias ViewModelType = ViewType.ViewModelType
    
    var viewModel: ViewModelType!
    
    let disposeBag = DisposeBag()
    
    let needShowPreloader = PublishSubject<Bool>()
    let showErrorAlert = PublishSubject<Error>()
    let showOkAlert = PublishSubject<(String, String)>()
    let showOkAlertWithCompletion = PublishSubject<(String, String, () -> Void)>()
    
    var UI: ViewType {
        return view as! ViewType
    }
    
    var hideNavigationBarIfExist: Bool = false
    var hideTabBarIfExist: Bool = true
    var authRotation: Bool = false
    var useBackgrounColorFromTheme = true
    
    var interfaceOrientations: UIInterfaceOrientationMask = .portrait
    
    override var shouldAutorotate: Bool {
        return authRotation
    }

    // Specify the orientation.
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return interfaceOrientations
    }
    
    deinit {
        print("Deinit:\(self). DisposeBag:\(disposeBag)")
    }
    // MARK: - Init
    convenience init(viewModel: ViewModelType, authRotation: Bool = false, interfaceOrientations: UIInterfaceOrientationMask = .portrait) {
        self.init()
        self.authRotation = authRotation
        self.interfaceOrientations = interfaceOrientations
        self.viewModel = viewModel
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        
       
        navigationController?.setNavigationBarHidden(hideNavigationBarIfExist, animated: false)
        //navigationController?.navigationBar.prefersLargeTitles = !hideNavigationBarIfExist
//        navigationController?.navigationBar.tintColor = ThemeManager.shared.currentTheme.value == .light
//            ? .black
//            : .white
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        
        hideTabBarIfExist ? hidenTabBar() : shownTabBar()
        
        NotificationCenter.default
            .addObserver(self, selector: #selector(keyboardChangeFrameNotification), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(keyboardWillShowHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(keyboardWillShowHideNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func addDefaultNavigation() {
        navigationItem.setLeftElements(items: .back, disposeBag: disposeBag)[.back]!.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                _ = (self?.viewModel as? SceneCoordinatorDelegate)?.popBack().subscribe()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Override
    override func loadView() {
        if let viewfromNib: ViewType = ViewType.fromNib() {
            self.view = viewfromNib
        }
        else { self.view = ViewType(frame: UIScreen.main.bounds) }
    }
    
    // MARK: - Setup
    func initialize() {
        setupUI()
        
        if let viewControllers = navigationController?.viewControllers, viewControllers.count > 1 {
            addDefaultNavigation()
        }
        
        setupBindings()
        UI.bind(to: viewModel)
    }
    
    func setupUI() {
        
//        if useBackgrounColorFromTheme {
//            ThemeManager.shared.currentTheme
//                .map{ $0.environment.backgroundColor }
//                .bind(to: view.rx.backgroundColor)
//                .disposed(by: disposeBag)
//        }
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
//        if let navigationController = self.navigationController {
//            ThemeManager.shared.currentTheme
//                .map{ $0.environment.backgroundColor }
//                .bind(to: navigationController.view.rx.backgroundColor)
//                .disposed(by: disposeBag)
//
//            ThemeManager.shared.currentTheme
//                .map{ $0.environment.backgroundColor }
//                .bind(to: navigationController.navigationBar.rx.barTintColor)
//                .disposed(by: disposeBag)
//        }
        
//        navigationController?.view.backgroundColor = ThemeManager.Colors.odrex.color
//        navigationController?.navigationBar.barTintColor = ThemeManager.Colors.odrex.color
        
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        if #available(iOS 13.0, *) {
//            return ThemeManager.shared.currentTheme.value == .light ? .darkContent : .lightContent
//        } else {
//            return ThemeManager.shared.currentTheme.value == .light ? .default : .lightContent
//        }
//    }
    
    func setupBindings() {
        
        viewModel.error
            .bind(to: showErrorAlert)
            .disposed(by: disposeBag)
        
//        ThemeManager.shared.currentTheme
//            .delay(.seconds(0), scheduler: MainScheduler.asyncInstance)
//            .subscribe(onNext: {[weak self]_ in
//                self?.setNeedsStatusBarAppearanceUpdate()
//            })
//            .disposed(by: disposeBag)
        
        needShowPreloader
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (value) in
                guard let `self` = self else { return }
                value ? self.showPreloader() : self.hidePreloader()
            }).disposed(by: disposeBag)
        
        showErrorAlert
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (value) in
                guard let `self` = self else { return }
                let alertContent = value.nsError.alertContent()
                AlertManager.alertOK(title: alertContent.title, message: alertContent.message, completion: nil)
            }).disposed(by: disposeBag)
        
        showOkAlert
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (title, message) in
                guard let `self` = self else { return }
                AlertManager.alertOK(title: title, message: message, completion: nil)
            }).disposed(by: disposeBag)
        
        showOkAlertWithCompletion
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (title, message, completion) in
                guard let `self` = self else { return }
                AlertManager.alertOK(title: title, message: message, completion: completion)
            }).disposed(by: disposeBag)
    }
    
    func keyboardNotified(endFrame: CGRect) { }
    
    func keyboardWillShow() {}
    
    func keyboardWillHide() {}
    
    func isKeyboardGoingToHide(_ endFrame: CGRect) -> Bool {
        return endFrame.origin.y >= UIScreen.main.bounds.size.height
    }
    
    @objc func keyboardChangeFrameNotification(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo as? [String:Any],
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        
        let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseOut.rawValue
        let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        self.keyboardNotified(endFrame: endFrame)
        
        UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func keyboardWillShowHideNotification(_ notification: Notification) {
        notification.name == UIResponder.keyboardWillHideNotification ? keyboardWillHide() : keyboardWillShow()
    }
}
