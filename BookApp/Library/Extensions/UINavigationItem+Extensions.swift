//
//  UINavigationItem+Extensions.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import UIKit
import RxSwift

extension UINavigationItem {
    
    @discardableResult
    func setLeftElements(items: NavBarItems..., disposeBag: DisposeBag) -> [NavBarItems: UIView] {
        let produce = produceBarItems(by: items, disposeBag: disposeBag)
        
        leftBarButtonItems = produce.items
        
        return produce.views
    }
    
    @discardableResult
    func setRightElements(items: NavBarItems..., disposeBag: DisposeBag) -> [NavBarItems: UIView] {
        let produce = produceBarItems(by: items, disposeBag: disposeBag)
        
        rightBarButtonItems = produce.items
        
        return produce.views
    }
    
    private func produceBarItems(by keys: [NavBarItems], disposeBag: DisposeBag) -> (items: [UIBarButtonItem], views: [NavBarItems: UIView]) {
        var views: [NavBarItems: UIView] = [:]
        var barItems: [UIBarButtonItem] = []
       
        for item in keys {
            let barItem = item.barButtonItem(disposeBag: disposeBag)
            views[item] = barItem.customView!
            barItems.append(barItem)
        }
        
        return (barItems, views)
    }
    
    func addSearch() -> UISearchController {
        let controler = UISearchController(searchResultsController: nil)
        let searchBar = controler.searchBar

        searchBar.backgroundImage = nil
        searchBar.placeholder = "Tech search..."
        searchBar.isTranslucent = false
        
        if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
            searchField.layer.borderColor = UIColor(red: 0.93, green: 0.93, blue: 0.96, alpha: 1).cgColor
            searchField.layer.borderWidth = 1
            searchField.layer.masksToBounds = true
            searchField.layer.cornerRadius = 10
            searchField.backgroundColor = .white
            searchField.textColor = .lightGray
            
            let estimatedSize = searchField.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            let rect = CGRect(x: searchField.frame.minX,
                              y: searchField.frame.minY,
                              width: estimatedSize.width,
                              height: 40)
            
            searchBar.setSearchFieldBackgroundImage(searchField.imageWithColor(color: .clear, inputRect: rect), for: .normal)
        }
        
        searchController = controler
        hidesSearchBarWhenScrolling = false
        
        return controler
    }
    
    func manageSearcController() {
        if searchController == nil {
            searchController = addSearch()
            
        } else if searchController?.searchBar.isHidden == false {
            searchController?.searchBar.isHidden = true
        }
    }
    
    func removeSearch() {
        searchController = nil
    }
    
    func addLogo() {
        let view = UIBarButtonItem.logoImageView
        titleView = UIView()
        titleView?.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.center.equalToSuperview()
        }
        
        titleView?.layoutIfNeeded()
    }
}

