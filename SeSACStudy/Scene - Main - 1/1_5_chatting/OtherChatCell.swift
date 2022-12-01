//
//  OtherChatCell.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/30.
//

import UIKit

class OtherChatCell: MyChatCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        chatLabel.backgroundColor = .clear
        boxView.backgroundColor = .clear
        boxView.layer.borderWidth = 1
        boxView.layer.borderColor = UIColor.gray2.cgColor
    }
    override func makeConstraints() {
        chatLabel.snp.makeConstraints { make in
            make.top.equalTo(boxView.snp.top).offset(10)
            make.leading.equalTo(snp.leading).offset(32)
            make.bottom.equalTo(boxView.snp.bottom).offset(-10)
            make.width.lessThanOrEqualTo(232)
        }
        boxView.snp.makeConstraints { make in
            make.leading.equalTo(chatLabel.snp.leading).offset(-16)
            make.trailing.equalTo(chatLabel.snp.trailing).offset(16)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-8)
        }
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(boxView.snp.trailing).offset(8)
            make.bottom.equalTo(boxView.snp.bottom)
        }
    }
}
