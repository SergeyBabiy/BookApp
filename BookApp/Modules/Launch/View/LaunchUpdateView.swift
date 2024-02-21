//
//  LaunchUpdateView.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import RxSwift
import UIKit

class LaunchUpdateView: View, ViewModelConfigurable {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let disposeBag = DisposeBag()
    
    override func setup() {
        super.setup()
        backgroundColor = .purple
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("Hello!")
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       options: [UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat],
                       animations: {[weak self] in
                        self?.imageView.alpha = 0.7
                        self?.imageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                       }, completion: nil)
    }
    
    func bind(to viewModel: LaunchUpdateViewModel) {
        viewModel.inputs.update()
    }
}

