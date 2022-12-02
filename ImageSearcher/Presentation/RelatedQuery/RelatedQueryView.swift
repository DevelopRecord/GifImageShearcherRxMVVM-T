//
//  RelatedQueryView.swift
//  ImageSearcher
//
//  Created by 이재혁 on 2022/12/01.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class RelatedQueryView: UIView {
    
    // MARK: - Model type implemente
    typealias Model = Void
    
    let actionTrigger = PublishRelay<RelatedQueryActionTrigger>()
    
    var disposeBag = DisposeBag()
    
    lazy var relatedQueryTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.delegate = self
        $0.dataSource = self
        $0.register(RelatedQueryCell.self, forCellReuseIdentifier: RelatedQueryCell.identifier)
    }
    
    lazy var searchBar = UISearchBar().then {
        $0.placeholder = "검색어 입력"
    }
    
    // MARK: - Outlets
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        bindData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func setupLayout() {
        backgroundColor = .systemBackground
        
        addSubview(relatedQueryTableView)
        relatedQueryTableView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    private func bindData() {
        searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { .searchQuery($0) }
            .bind(to: actionTrigger)
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .map { .searchButtonClicked }
            .bind(to: actionTrigger)
            .disposed(by: disposeBag)
        
        relatedQueryTableView.rx.modelSelected(Giphy.self)
            .map { .modelSelected($0) }
            .bind(to: actionTrigger)
            .disposed(by: disposeBag)
    }
    
    @discardableResult
    func setupDI(gifsRelay: BehaviorRelay<[Giphy]>) -> Self {
        relatedQueryTableView.delegate = nil
        relatedQueryTableView.dataSource = nil
        relatedQueryTableView.rx.setDelegate(self).disposed(by: disposeBag)
        gifsRelay
            .asObservable()
            .bind(to: relatedQueryTableView.rx.items(cellIdentifier: RelatedQueryCell.identifier, cellType: RelatedQueryCell.self)) { _, giphy, cell in
                cell.setupRequest(with: giphy)
            }.disposed(by: disposeBag)
        
        return self
    }
    
    @discardableResult
    func setupDI(actionRelay: PublishRelay<RelatedQueryActionTrigger>) -> Self {
        actionTrigger
            .bind(to: actionRelay)
            .disposed(by: disposeBag)
        
        return self
    }
    
    
}

extension RelatedQueryView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RelatedQueryCell.identifier, for: indexPath) as? RelatedQueryCell else { return UITableViewCell() }
        return cell
    }
}
