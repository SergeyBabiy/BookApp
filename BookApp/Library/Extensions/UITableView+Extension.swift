//
//  UITableView+Extension.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import UIKit
import RxSwift

extension UITableView {
    
    func beginLoading() -> Completable {
        return Completable.create {[weak self] (completable) -> Disposable in
            guard
                let `self` = self,
                let refreshControl = self.refreshControl
            else {
                completable(.error(NSError.error("Deinited.")))
                return Disposables.create()
            }
            
            let top = self.adjustedContentInset.top
            let y = refreshControl.frame.maxY + top
            
            self.setContentOffset(CGPoint(x: 0, y: -y), animated: true)
            self.refreshControl?.beginRefreshing()
            
            completable(.completed)
            return Disposables.create()
        }
    }
    
    func endLoading() -> Completable {
        return Completable.create {[weak self] (completable) -> Disposable in
            guard
                let `self` = self,
                let refreshControl = self.refreshControl
            else {
                completable(.error(NSError.error("Deinited.")))
                return Disposables.create()
            }
            
            refreshControl.endRefreshing()
            self.setContentOffset(CGPoint(x: 0, y:  0.0), animated: true)
            
            completable(.completed)
            return Disposables.create()
        }
    }
    
    func isLastVisibleCell(at indexPath: IndexPath) -> Bool {
        guard let lastIndexPath = indexPathsForVisibleRows?.last else {
            return false
        }

        return lastIndexPath == indexPath
    }
    
    func reloadData(completion: @escaping ()->()) {

        UIView.performWithoutAnimation {
            reloadData()
        }

        completion()
    }

    func reloadSectionsWithoutAnimation(_ sections: IndexSet){
        UIView.performWithoutAnimation {
            reloadSections(sections, with: .fade)
        }
    }

    func reloadSectionWithouAnimation(section: Int) {
        UIView.performWithoutAnimation {
            let offset = self.contentOffset
            self.reloadSections(IndexSet(integer: section), with: .none)
            self.contentOffset = offset
        }
    }

    func reloadItemsWithoutAnimation(at indexPaths: [IndexPath]){
        UIView.performWithoutAnimation {
            reloadRows(at: indexPaths, with: .fade)
        }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let view =  dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Could not dequeue view with identifier: \(T.reuseIdentifier)")
        }
        
        return view
    }
}

