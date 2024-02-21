//
//  DebugCell.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import UIKit

class DebugCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
        
        addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.height.greaterThanOrEqualTo(40)
            make.top.bottom.right.equalToSuperview().inset(5)
            make.left.equalToSuperview().inset(15)
        })
        return label
    }()
    
    func configure(with viewModel: DebugScene) {
        titleLabel.text = viewModel.title
    }
}
