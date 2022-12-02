//
//  HomeView.swift
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

class HomeView: UIView {
    
    // MARK: - Model type implemente
    typealias Model = Void
    
    var disposeBag = DisposeBag()
    
    let actionTrigger = PublishRelay<SearchActionTrigger>()
    
    lazy var itemCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
        $0.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.identifier)
    }
    
    lazy var searchController = UISearchController(searchResultsController: nil).then {
        $0.searchBar.placeholder = "키워드를 검색하세요."
        $0.obscuresBackgroundDuringPresentation = false
        $0.searchBar.setupKeyboardToolbar()
        $0.searchResultsUpdater = self
    }
    
    lazy var induceSearchView = InduceSearchView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        bindData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupLayout() {
        backgroundColor = .systemBackground
        
        addSubview(itemCollectionView)
        itemCollectionView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    private func bindData() {
        searchController.searchBar.rx.text
            .orEmpty
            .debounce(.milliseconds(350), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { .searchQuery($0) }
            .bind(to: actionTrigger)
            .disposed(by: disposeBag)
    }
    
    @discardableResult
    func setupDI(actionRelay: PublishRelay<SearchActionTrigger>) -> Self {
        actionTrigger
            .bind(to: actionRelay)
            .disposed(by: disposeBag)
        
        return self
    }
    
    @discardableResult
    func setupDI(gifsRelay: BehaviorRelay<[Giphy]>) -> Self {
        itemCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        /// item bind
        gifsRelay
            .asObservable()
            .do(onNext: { [weak self] in
                guard let self = self else { return }
                self.itemCollectionView.backgroundView = $0.isEmpty ? self.induceSearchView : nil
            })
            .bind(to: itemCollectionView.rx.items(cellIdentifier: ItemCell.identifier, cellType: ItemCell.self)) { _, giphy, cell in
                cell.setupRequest(with: giphy)
                cell.backgroundColor = .red
        }.disposed(by: disposeBag)
        
        return self
    }
}

extension HomeView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    }
    
}

extension HomeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = bounds.width / 4 - 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
