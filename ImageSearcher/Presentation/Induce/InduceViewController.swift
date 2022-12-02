//
//  InduceViewController.swift
//  ImageSearcher
//
//  Created by 이재혁 on 2022/12/02.
//

import UIKit

class InduceViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    let subView = InduceSearchView()
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        setupNavigationBar(title: "메인")
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearch))
        navigationItem.setRightBarButton(barButton, animated: true)
        
        view.addSubview(subView)
        subView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    @objc private func handleSearch() {
        let controller = RelatedQueryViewController()
        controller.viewModel = RelatedQueryViewModel()
        navigationController?.pushViewController(controller, animated: true)
    }
}
