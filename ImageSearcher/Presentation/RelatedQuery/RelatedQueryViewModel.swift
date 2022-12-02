//
//  RelatedQueryViewModel.swift
//  ImageSearcher
//
//  Created by 이재혁 on 2022/12/01.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum RelatedQueryActionTrigger {
    case searchQuery(String)
    case searchButtonClicked
    case modelSelected(Giphy)
}

class RelatedQueryViewModel: ViewModelType {
    
    // MARK: - ViewModelType Protocol
    typealias ViewModel = RelatedQueryViewModel
    
    var disposeBag = DisposeBag()
    
    /// Gif 리스트
    private var gifsRelay = BehaviorRelay<[Giphy]>(value: [])
    /// 검색 쿼리
    private var query = BehaviorRelay<String>(value: "")
    /// 아웃풋
    private var outputRequest = PublishRelay<OutputRequestType>()
    
    struct Input {
        let actionTrigger: PublishRelay<RelatedQueryActionTrigger>
    }
    
    struct Output {
        let gifsRelay: BehaviorRelay<[Giphy]>
        let outputRequest: PublishRelay<OutputRequestType>
    }
    
    func transform(req: ViewModel.Input) -> ViewModel.Output {
        req.actionTrigger.subscribe(onNext: actionProcess).disposed(by: disposeBag)
        
        return Output(gifsRelay: gifsRelay, outputRequest: outputRequest)
    }
    
    func actionProcess(type: RelatedQueryActionTrigger) {
        switch type {
        case .searchQuery(let searchQuery):
            query.accept(searchQuery)
            fetchTitle()
        case .searchButtonClicked:
            print("searchButtonClicked")
        case .modelSelected(let giphy):
            outputRequest.accept(.searchTitle(giphy.title))
        }
    }
    
    private func fetchTitle() {
        let response = APIService.shared.fetchGifs2(query: query.value)
        
        response.subscribe({ [weak self] state in
            guard let self = self else { return }
            switch state {
            case .success(let giphyResponse):
                if let giphy = giphyResponse.data {
                    self.gifsRelay.accept(giphy)
                }
                
            case .failure(let error):
                print("ERR: \(error.localizedDescription)")
            }
        }).disposed(by: disposeBag)
        
    }
}

extension RelatedQueryViewModel {
    enum OutputRequestType {
        case searchTitle(String?)
    }
}
