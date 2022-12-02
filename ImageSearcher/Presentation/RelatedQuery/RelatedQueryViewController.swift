//
//  RelatedQueryViewController.swift
//  ImageSearcher
//
//  Created by 이재혁 on 2022/12/01.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class RelatedQueryViewController: UIViewController {
    typealias ViewModel = RelatedQueryViewModel
    
    // MARK: - ViewModelProtocol
    var viewModel: ViewModel!
    
    // MARK: - Properties
    
    let actionTrigger = PublishRelay<RelatedQueryActionTrigger>()
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupLayout()
        bindingViewModel()
    }
    
    // MARK: - Binding
    func bindingViewModel() {
        let response = viewModel.transform(req: ViewModel.Input(actionTrigger: actionTrigger))
        
        subView
            .setupDI(actionRelay: actionTrigger)
            .setupDI(gifsRelay: response.gifsRelay)
        
        response.outputRequest
            .bind(onNext: { [weak self] request in
                guard let self = self else { return }
                switch request {
                case .searchTitle(let searchTitle):
                    print("asdf: \(searchTitle)")
                    let controller = HomeViewController()
                    controller.viewModel = HomeViewModel(searchTitle: searchTitle)
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }).disposed(by: disposeBag)
    }
    
    // MARK: - View
    let subView = RelatedQueryView()
    
    func setupLayout() {
        setupNavigationBar(searchBar: subView.searchBar)
        
        self.view.addSubview(subView)
        subView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
}
