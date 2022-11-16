//
//  ProfileViewCell.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/14.
//

import UIKit
import SnapKit

class ProfileViewCell: UICollectionViewCell {
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    let imageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NotoSansKR-Regular", size: 16)
        return label
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
        [lineView, imageView, label].forEach { self.contentView.addSubview($0) }
    }
    
    func makeConstraints() {
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.centerY.equalTo(self.snp.centerY)
            make.width.height.equalTo(24)
        }
        label.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(12)
            make.centerY.equalTo(self.snp.centerY)
        }
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalTo(17)
            make.trailing.equalTo(-15)
            
        }
    }
}
