//
//  DebugView.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import RxSwift

class DebugView: View, ViewModelConfigurable {
    let disposeBag = DisposeBag()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.register(DebugCell.self, forCellReuseIdentifier: DebugCell.reuseIdentifier)
        
        addSubview(tableView)
        tableView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.left.bottom.right.equalToSuperview()
        })
        return tableView
    }()
    
    func bind(to viewModel: DebugViewModel) {
        viewModel.outputs.scenes
            .bind(to: tableView.rx.items(cellIdentifier: DebugCell.reuseIdentifier, cellType: DebugCell.self)){row, item, cell in
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.modelSelected(DebugScene.self),
                       tableView.rx.itemSelected)
            .subscribe(onNext: {[unowned self] in
                _ = viewModel.inputs.selectedScene(scene: $0.0).subscribe()
                self.tableView.deselectRow(at: $0.1, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

