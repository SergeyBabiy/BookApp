//
//  ViewModelBindings.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import Foundation
import RxSwift

protocol ViewModelBindings: BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    var inputs: Input { get }
    var outputs: Output { get }
}

protocol ViewModelConfigurable {
    associatedtype ViewModelType: ViewModelBindings
    
    var disposeBag: DisposeBag { get }
    
    func bind(to viewModel: ViewModelType)
}

