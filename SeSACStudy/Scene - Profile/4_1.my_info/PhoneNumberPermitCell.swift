//
//  PhoneNumberPermitCell.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/15.
//

import UIKit
import SnapKit

class PhoneNumberPermitCell: BaseCollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        return label
    }()
    let mySwitch: UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.tintColor = .gray3
        mySwitch.onTintColor = .brandGreen
        return mySwitch
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func setupUI() {
        [label, mySwitch].forEach { self.contentView.addSubview($0) }
    }
    override func makeConstraints() {
        label.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
        }
        mySwitch.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
            
        }
        
    }
}
