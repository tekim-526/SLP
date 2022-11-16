//
//  LaunchScreenView.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/16.
//

import UIKit

class LaunchScreenView: BaseView {
    let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splash_logo")
        return imageView
    }()
    let titleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "txt")
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func setupUI() {
        self.addSubview(logoImage)
        self.addSubview(titleImage)
    }
    override func makeConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        logoImage.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(220)
            make.leading.equalTo(safeArea).offset(78)
            make.trailing.equalTo(safeArea).offset(-78)
        }
        titleImage.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(35.44)
            make.leading.equalTo(safeArea).offset(42)
            make.trailing.equalTo(safeArea).offset(-42)

        }
    }
    
}
