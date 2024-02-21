//
//  InternetReachbillity.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import Reachability
import RxReachability
import RxSwift
import UIKit
import SnapKit

var InternetReachbility: InternetReachbilityManager { InternetReachbilityManager.shared }

class InternetReachbilityManager {
    
    struct Error {
        static var noConnection: String { "No connection" }
        static let noConnectionTitle = "Internet"
    }
    
    static let shared = InternetReachbilityManager()
    static let headTag: Int = 312943
    
    var heightContainer: CGFloat{
        var  height = UIApplication.shared.keyWindow!.safeAreaInsets.top
        /// #iphone < iphoneX
        if height == 20 {
            height = 33
        }
        
        return height
    }
    
    var widthContainer: CGFloat{
        return (UIApplication.shared.keyWindow)!.frame.width
    }
    
    lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.tag = InternetReachbilityManager.headTag
        view.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
//        label.font = ThemeManager.Font.avenirMedium.font(with: 10)
        label.contentMode = .bottom
        
        container.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.height.equalTo(12)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(3)
        }
        
        return label
    }()
    
    var reachabilityChanged: Observable<Reachability> { Reachability.rx.reachabilityChanged }
    var status: Observable<Reachability.Connection> { Reachability.rx.status }
    var connection: Reachability.Connection { reachability!.connection }
    
    var isInternetConected: Bool { connection != .none }
    var internetConectionChanges: Observable<Bool> { Reachability.rx.status.map{ $0 != .none } }
    
    private let disposeBag = DisposeBag()
    private var reachability: Reachability?
    private let notificationFeedBack = UINotificationFeedbackGenerator()
    //private var coordinator: SceneCoordinator!
    private var window: UIWindow { UIApplication.shared.keyWindow! }
    
    private init() {
       
    }
    
    func start(with coordinator: SceneCoordinator) {
        //self.coordinator = coordinator
        print("✅InternetReachbility start working.")
        container.isHidden = false
        
        setupBindings()
    }
    
    func waitingInternetConnectionAndThen(delay: RxTimeInterval = .nanoseconds(0), complete: @escaping () -> Void) -> Disposable {
        return internetConectionChanges
            .skipWhile{ !$0 } ///waiting only internet connection
            .take(1)
            .delay(delay, scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in complete() })
    }
    
    func waitingInternetConnection(delay: RxTimeInterval = .nanoseconds(0)) -> Single<Void> {
        return internetConectionChanges
            .skipWhile{ !$0 } ///waiting only internet connection
            .map { _ in () }
            .take(1)
            .delay(delay, scheduler: MainScheduler.asyncInstance)
            .asSingle()
    }
    
    private func setupBindings() {
//        Observable.combineLatest(internetConectionChanges.distinctUntilChanged(),
//                                 Localization.bag[.haveInternet]!,
//                                 Localization.bag[.haveNoInternet]!)
//            .map{ $0.0 }
//            .map{ Localization[$0 ? .haveInternet : .haveNoInternet].lowercased() }
//            .bind(to: titleLabel.rx.text)
//            .disposed(by: disposeBag)
//        
//        internetConectionChanges
//            .distinctUntilChanged()
//            .map{ $0 ? #colorLiteral(red: 0.02097483273, green: 0.8932423858, blue: 0.0700268183, alpha: 1) : ThemeManager.Colors.red }
//            .bind(to: container.rx.backgroundColor )
//            .disposed(by: disposeBag)
        
        internetConectionChanges
            .distinctUntilChanged()
            .enumerated()
            .skipWhile{ return ($0.index == 0 && $0.element == true) }
        //.delay(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .map{ $0.element }
            .subscribe(onNext: { isConnected in
                print("InternetReachbility change status to:\(self.connection)")
              
                DispatchQueue.main.asyncAfter(deadline: .now() + (isConnected ? 0.1 : 1)) {
                    self.notificationFeedBack.notificationOccurred(.warning)
                }
        
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isConnected ? self.hideHead() : self.showHead()
                }
            })
            .disposed(by: disposeBag)
        
//        coordinator
//            .rootChanged
//            .delay(.milliseconds(100), scheduler: MainScheduler.asyncInstance)
//            .subscribe(onNext: {
//                guard !self.isInternetConected else { return }
//                self.showHead()
//            })
//            .disposed(by: disposeBag)
    }
    
    func showHead() {
        guard !window.subviews.contains(container) else { return }
        
        window.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(-heightContainer)
            make.left.right.equalToSuperview().priority(.high)
            make.width.equalTo(widthContainer).priority(.medium)
            make.height.equalTo(heightContainer)
        }
        UIView.performWithoutAnimation {
            self.container.layoutIfNeeded()
        }
        
        DispatchQueue.main.async {
            self.container.snp.updateConstraints { (update) in
                update.top.equalToSuperview().inset(0)
            }
            
            self.window.layoutIfNeeded(duration: 0.3)
        }
    }
    
    func hideHead() {
        guard container.superview != nil else { return }
        
        container.snp.updateConstraints { (update) in
            update.top.equalToSuperview().inset(-heightContainer)
        }
        
        window.layoutIfNeeded(duration: 0.3){[weak self] in
            self?.container.removeFromSuperview()
        }
    }
}

