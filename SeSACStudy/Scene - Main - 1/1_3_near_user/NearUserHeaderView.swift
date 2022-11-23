//
//  NearUserHeaderView.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/21.
//

import UIKit

class NearUserHeaderView: UICollectionReusableView {
   
    let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "sesac_background_1")
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        [imageView].forEach { self.addSubview($0) }
    }
    
    func makeConstraints() {
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.centerY.equalTo(self.snp.centerY)
        }
        
    }
}
