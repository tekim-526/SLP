//
//  WriteStudyCell.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/17.
//

import UIKit

import SnapKit

class WriteStudyCell: BaseCollectionViewCell {
    let button: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = .init(top: 4, leading: 12, bottom: 4, trailing: 12)
        configuration.imagePlacement = .trailing
        let button = UIButton()
        
        button.titleLabel?.font = UIFont(name: "NotoSansKR-Light", size: 14)
        button.layer.cornerRadius = 8
        button.configuration = configuration
        button.isUserInteractionEnabled = false
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func setupUI() {
        self.addSubview(button)
    }
    override func makeConstraints() {
        button.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
