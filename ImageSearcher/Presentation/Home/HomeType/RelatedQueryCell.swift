//
//  RelatedQueryCell.swift
//  ImageSearcher
//
//  Created by 이재혁 on 2022/12/01.
//

import UIKit

class RelatedQueryCell: UITableViewCell {
    
    static let identifier = "RelatedQueryCell"
    
    // MARK: - Properties
    let magnifyingGlassImage = UIImageView().then {
        $0.image = UIImage(systemName: "magnifyingglass")
        $0.tintColor = .lightGray
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
    }
    
    let relatedQueryLabel = UILabel().then {
        $0.text = "연관된 검색어"
        $0.font = UIFont.systemFont(ofSize: 17)
    }
    
    // MARK: - Initializing
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubviews([magnifyingGlassImage, relatedQueryLabel])
        
        magnifyingGlassImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        relatedQueryLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(magnifyingGlassImage.snp.trailing).offset(10)
        }
    }
    
    func setupRequest(with gif: Giphy) {
        relatedQueryLabel.text = gif.title
    }
}
