//
//  BaseAlertView.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import UIKit
import RxSwift
import RxCocoa

class CustomAlertView: View, ViewModelConfigurable {
    
    let disposeBag: DisposeBag = DisposeBag()
    
    lazy var mainContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.autoresizingMask = .flexibleHeight
        
        addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.center.equalToSuperview().priority(.high)
            make.left.right.equalToSuperview().inset(30)
            make.height.lessThanOrEqualTo(frame.height - 100)
        })
        return view
    }()
    
    lazy var logo: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        mainContainer.addSubview(imageView)
        imageView.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().inset(14)
            make.height.equalTo(28)
            make.width.equalTo(118)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(mainStack.snp.top).offset(-15)
        })
        
        return imageView
    }()
    
    lazy var mainStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 30
        
        mainContainer.addSubview(stackView)
        stackView.snp.makeConstraints({ (make) in
            make.bottom.equalToSuperview().inset(25)
            make.left.right.equalToSuperview().inset(10)
        })
        
        stackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(buttonStack)
        return stackView
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
//        textView.font = ThemeManager.Font.avenirBlack.font(with: 18)
        textView.textColor = .darkGray
//        textView.textContainerInset = .init(around: 4)
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.textAlignment = .center
        textView.isEditable = false
        
        return textView
    }()
    
    lazy var buttonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        return stackView
    }()

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        showModalWithAnimation()
    }
    
    override func setup() {
        super.setup()
        logo.isHidden = false
    }
    
    func bind(to viewModel: CustomAlertViewModel) {
        textView.text = viewModel.outputs.text
        
        buttonStack.isHidden = viewModel.outputs.actions.isEmpty
        
        viewModel.outputs.actions
            .forEach { buttonConfig in
                let button = UIButton()
                button.setTitle(buttonConfig.title, for: .normal)
                button.setTitleColor(buttonConfig.textColor, for: .normal)
                button.backgroundColor = buttonConfig.backgroundColor
                button.layer.cornerRadius = 8
                button.layer.masksToBounds = true
                button.bindZooming(with: disposeBag)
                
                button.rx
                    .tapGesture()
                    .when(.recognized)
                    .subscribe(onNext: {[weak self] _ in
                        _ = self?.dismissModalWithAnimation()
                                .andThen( viewModel.inputs.pop() )
                                .subscribe(onCompleted: { buttonConfig.action?() })
                    })
                    .disposed(by: disposeBag)
                
                buttonStack.addArrangedSubview(button)
                button.snp.makeConstraints { (make) in
                    make.height.equalTo(44)
                }
            }
        
        logo.image = UIImage(named: "logo_dark")
    }
}

