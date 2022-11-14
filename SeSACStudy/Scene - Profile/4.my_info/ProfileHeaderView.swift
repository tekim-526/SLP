//
//  ProfileHeaderView.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/14.
//

import UIKit

class ProfileHeaderView: UICollectionReusableView {
   
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    
    let button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    let arrowView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "more_arrow")
        image.tintColor = .gray7
        return image
    }()
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NotoSansKR-Medium", size: 16)
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
        [arrowView, lineView, imageView, label, button].forEach { self.addSubview($0) }
    }
    
    func makeConstraints() {
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.centerY.equalTo(self.snp.centerY)
            make.width.height.equalTo(48)
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
        button.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        arrowView.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-22.5)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
}
