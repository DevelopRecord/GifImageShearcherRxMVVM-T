//
//  ItemCell.swift
//  ImageSearcher
//
//  Created by 이재혁 on 2022/12/01.
//

import UIKit
import Kingfisher

class ItemCell: UICollectionViewCell {
    
    static let identifier = "ItemCell"
    
    // MARK: Properties
    lazy var thumbnailImage = UIImageView().then {
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 8
    }
    
    let title = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.numberOfLines = 2
        $0.text = "제목제목제목제목제목제목제목제목제목제목"
    }
    
    let usernameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.numberOfLines = 1
        $0.text = "부제목부제목부제목부제목부제목부제목부제목부제목부제목부제목부제목부제목부제목부제목부제목부제목부제목부제목부제목부제목부제목부제목부제목부제목"
    }
    
    // MARK: Initializing
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(thumbnailImage)
        
        thumbnailImage.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    func setupRequest(with giphy: Giphy) {
        guard let urlString = giphy.images?.fixedWidthSmall?.url, let url = URL(string: urlString) else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.thumbnailImage.kf.setImage(with: url)
        }
    }
}
