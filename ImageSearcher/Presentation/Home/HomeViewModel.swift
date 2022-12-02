//
//  HomeViewModel.swift
//  ImageSearcher
//
//  Created by 이재혁 on 2022/12/01.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum SearchActionTrigger {
    case searchQuery(String)
}

class HomeViewModel: ViewModelType {
    
    // MARK: - ViewModelType Protocol
    typealias ViewModel = HomeViewModel
    
    var disposeBag = DisposeBag()
    
    /// Gif 리스트
    private var gifsRelay = BehaviorRelay<[Giphy]>(value: [])
    /// 검색 쿼리
    private var query = BehaviorRelay<String>(value: "")
    
    var searchTitle: String!
    
    init(searchTitle: String?) {
        self.searchTitle = searchTitle
    }
    
    struct Input {
        let viewLoadTrigger: Observable<Void>
        let actionTriggers: PublishRelay<SearchActionTrigger>
    }
    
    struct Output {
        let gifsRelay: BehaviorRelay<[Giphy]>
    }
    
    func transform(req: ViewModel.Input) -> ViewModel.Output {
        req.viewLoadTrigger.subscribe(onNext: fetchGif).disposed(by: disposeBag)
        
        req.actionTriggers.subscribe(onNext: actionProcess).disposed(by: disposeBag)
        
        return Output(gifsRelay: gifsRelay)
    }
    
    func actionProcess(type: SearchActionTrigger) {
        switch type {
        case .searchQuery(_):
//            self.query.accept(query)
//            fetchGif(query)
            print("searchQuery")
        }
    }
    func fetchGif() {
        let result = APIService.shared.fetchGifs2(query: searchTitle)
        
        result.subscribe({ [weak self] state in
            guard let self = self else { return }
            switch state {
            case .success(let giphyResponse):
                if let gifs = giphyResponse.data {
                    self.gifsRelay.accept(gifs)
                }
                
            case .failure(let error):
                print("Error111: \(error)")
            }
        }).disposed(by: disposeBag)
    }
}
