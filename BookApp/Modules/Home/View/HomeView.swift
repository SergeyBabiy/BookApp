//
//  HomeView.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import RxSwift

class HomeView: View, ViewModelConfigurable {
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bind(to viewModel: HomeViewModel) {
    }
}
