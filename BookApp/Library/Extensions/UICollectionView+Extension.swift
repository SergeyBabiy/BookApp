//
//  UICollectionView+Extension.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import UIKit
import RxSwift

extension UICollectionView {
    
    func selectedItem(with disposeBag: DisposeBag, completion: @escaping ((IndexPath)->())) {
        rx.itemSelected.subscribe(onNext: {
            completion($0)
        })
        .disposed(by: disposeBag)
    }
    
    func selectedModel<T>(with disposeBag: DisposeBag, model: T.Type, completion: @escaping ((T)->())) {
        rx.modelSelected(T.self).subscribe(onNext: {
            completion($0)
        })
        .disposed(by: disposeBag)
    }
    
    func makeNewLayoutBy(count items: Int, direction: ScrollDirection = .vertical) -> UICollectionViewFlowLayout{
        let layout = UICollectionViewFlowLayout()
        let padding: CGFloat = 10
        let widthWithoutPading = (self.frame.width - (CGFloat(items * items) * padding )) - 1

        layout.itemSize = CGSize(width: widthWithoutPading / (CGFloat(items)),
                                 height: self.frame.height - 2)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = direction
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: 0)
        return layout
    }

    func reloadSectionsWithoutAnimation(_ sections: IndexSet){
        UIView.performWithoutAnimation {
            reloadSections(sections)
        }
    }

    func reloadItemsWithoutAnimation(at indexPaths: [IndexPath]){
        UIView.performWithoutAnimation {
            reloadItems(at: indexPaths)
        }
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }
    
    func dequeueReusableView<T: UICollectionReusableView>(forIndexPath indexPath: IndexPath, with kind: String) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue view with identifier: \(T.reuseIdentifier)")
        }
        
        return view
    }
}

