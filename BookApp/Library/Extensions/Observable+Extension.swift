//
//  Observable+Extension.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import Foundation
import RxSwift
import RxCocoa


extension Observable {
    func bindIsLoad(for loader: BehaviorRelay<Bool>, _ disp: DisposeBag) {
        self
            .map{_ in false}
            .catchErrorJustReturn(false)
            .bind(to: loader)
            .disposed(by: disp)
    }
}
