//
//  Extension+.swift
//  ImageSearcher
//
//  Created by 이재혁 on 2022/12/01.
//

import UIKit

extension UIViewController {

    /// 네비게이션바 설정 함수
    func setupNavigationBar(title: String? = nil, isLargeTitle: Bool? = nil, searchController: UISearchController? = nil, searchBar: UISearchBar? = nil) {
        navigationItem.title = title
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.prefersLargeTitles = isLargeTitle ?? false
        navigationItem.searchController = searchController
        navigationItem.titleView = searchBar
    }
}

extension UIView {
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}

extension UISearchBar {

    /// 키보드 툴바
    func setupKeyboardToolbar() {
        let screenWidth = UIScreen.main.bounds.width
        let toolbar = UIToolbar(frame: .init(x: 0, y: 0, width: screenWidth, height: 50))
        toolbar.barStyle = .default
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        lazy var doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(dismissKeyboard))
        
        toolbar.sizeToFit()
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        inputAccessoryView = toolbar
    }
    
    @objc private func dismissKeyboard() {
        resignFirstResponder()
    }
}

extension UIImage {
    func resizeImage(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        print("화면 배율: \(UIScreen.main.scale)")// 배수
        print("origin: \(self), resize: \(renderImage)")
        
        return renderImage
    }
}
