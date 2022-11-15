//
//  AgeCell.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/15.
//

import UIKit
import SnapKit

class AgeCell: BaseCollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        return label
    }()
    let slider: UISlider = {
        let slider = UISlider()
        slider.tintColor = .brandGreen
        slider.thumbTintColor = .brandGreen
        
        return slider
    }()
    let rangeLabel: UILabel = {
        let label = UILabel()
        label.text = "18-25"
        label.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        label.textColor = .brandGreen
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func setupUI() {
        [label, rangeLabel, slider].forEach { self.contentView.addSubview($0) }
    }
    override func makeConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
        }
        rangeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
        }
        slider.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(14)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
        }
    }
}
