//
//  UIBarButtonItem+Extensions.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import UIKit
import RxSwift

enum NavBarItems {
    case back
    case menu
    case close
    case backWhite
    case call
    case park
    
    func barButtonItem(disposeBag: DisposeBag) -> UIBarButtonItem {
        switch self {
        case .back:
            return .backItem(disposeBag: disposeBag)
        case .menu:
            return .menuItem(disposeBag: disposeBag)
        case .close:
            return .closeItem(disposeBag: disposeBag)
        case .backWhite:
            return .backWhite(disposeBag: disposeBag)
        case .call:
            return .callItem(disposeBag: disposeBag)
        case .park:
            return .parkItem(disposeBag: disposeBag)
        }
    }
}

extension UIBarButtonItem {
    
    static func backItem(disposeBag: DisposeBag) -> UIBarButtonItem {
        
        let image = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFit
        button.contentEdgeInsets = .init(top: 12, left: 0, bottom: 12, right: 4)
        
        let barItem = UIBarButtonItem(customView: button)
        
        button.snp.makeConstraints { (make) in
            make.width.equalTo(30)
        }
        return barItem
    }
    
    static func backWhite(disposeBag: DisposeBag) -> UIBarButtonItem {
        
        let image = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFit
        button.contentEdgeInsets = .init(top: 12, left: 0, bottom: 12, right: 4)
        button.tintColor = .white
        let barItem = UIBarButtonItem(customView: button)
        
        button.snp.makeConstraints { (make) in
            make.width.equalTo(30)
        }
        return barItem
    }
    
    static func menuItem(disposeBag: DisposeBag) -> UIBarButtonItem {
        
        let image = UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFit
        button.contentEdgeInsets = .init(top: 12, left: 0, bottom: 12, right: 4)
        
        let barItem = UIBarButtonItem(customView: button)
        
        button.snp.makeConstraints { (make) in
            make.width.equalTo(30)
        }
        return barItem
    }
    
    static func callItem(disposeBag: DisposeBag) -> UIBarButtonItem {
        
        let image = UIImage(named: "call")?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFit
        button.contentEdgeInsets = .init(top: 8, left: 0, bottom: 8, right: 0)
        
        let barItem = UIBarButtonItem(customView: button)
        
        button.snp.makeConstraints { (make) in
            make.width.equalTo(30)
        }
        return barItem
    }
    
    static func parkItem(disposeBag: DisposeBag) -> UIBarButtonItem {
        
        let image = UIImage(named: "park")?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFit
        button.contentEdgeInsets = .init(top: 7, left: 0, bottom: 7, right: 0)
        
        let barItem = UIBarButtonItem(customView: button)
        
        button.snp.makeConstraints { (make) in
            make.width.equalTo(30)
        }
        return barItem
    }
    
    static func closeItem(disposeBag: DisposeBag) -> UIBarButtonItem {
        
        let image = UIImage(named: "exit")?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFit
        button.contentEdgeInsets = .init(top: 3, left: 3, bottom: 3, right: 3)
        
        let barItem = UIBarButtonItem(customView: button)
        
        button.snp.makeConstraints { (make) in
            make.size.equalTo(30)
        }
        return barItem
    }
    
    static var logoImageView: UIButton {
        let imageView = UIButton()
        imageView.setImage(UIImage(named: "logo"), for: .normal)
        imageView.imageView?.contentMode = .scaleAspectFit
        //imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        //imageView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        
        return imageView
    }
}

