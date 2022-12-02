//
//  HomeViewController.swift
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

class HomeViewController: UIViewController {
    typealias ViewModel = HomeViewModel
    
    // MARK: - ViewModelProtocol
    var viewModel: ViewModel!
    
    /// 뷰 로드 트리거
    private var viewLoadTrigger = PublishRelay<Void>()
    /// 사용자 액션 트리거
    let actionTriggers = PublishRelay<SearchActionTrigger>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupLayout()
        bindingViewModel()
        
        viewLoadTrigger.accept(())
    }
    
    // MARK: - Binding
    func bindingViewModel() {
        let response = viewModel.transform(req: ViewModel.Input(viewLoadTrigger: viewLoadTrigger.asObservable(), actionTriggers: actionTriggers))
        
        subView
            .setupDI(actionRelay: actionTriggers)
            .setupDI(gifsRelay: response.gifsRelay)
    }
    
    // MARK: - View
    let subView = HomeView()
    
    func setupLayout() {
        self.view.addSubview(subView)
        subView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc private func handleSearch() {
        let controller = RelatedQueryViewController()
        controller.viewModel = RelatedQueryViewModel()
        navigationController?.pushViewController(controller, animated: true)
    }
}
