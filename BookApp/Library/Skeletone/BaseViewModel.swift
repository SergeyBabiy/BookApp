//
//  BaseViewModel.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import Foundation
import RxSwift
import RxCocoa

protocol BaseViewModel {
    var error: PublishSubject<Error> { get }
}
