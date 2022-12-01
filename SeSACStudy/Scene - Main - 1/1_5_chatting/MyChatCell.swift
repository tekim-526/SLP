//
//  MyChatCell.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/30.
//

import UIKit

class MyChatCell: BaseCollectionViewCell {
    let boxView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandWhiteGreen
        view.layer.cornerRadius = 8
        return view
    }()
    let chatLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요! 저 평일은 저녁 8시에 꾸준히 하는데 7시부터 해도 괜찮아요"
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.textColor = .black
        label.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        return label
    }()
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray6
        label.backgroundColor = .clear
        label.text = "15:02"
        label.font = UIFont(name: "NotoSansKR-Regular", size: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func setupUI() {
        [boxView, chatLabel, timeLabel].forEach { addSubview($0) }
    }
    override func makeConstraints() {
        chatLabel.snp.makeConstraints { make in
            make.top.equalTo(boxView.snp.top).offset(10)
            make.trailing.equalTo(self.snp.trailing).inset(32)
            make.bottom.equalTo(boxView.snp.bottom).offset(-10)
            make.width.lessThanOrEqualTo(232)
        }
        boxView.snp.makeConstraints { make in
            make.leading.equalTo(chatLabel.snp.leading).offset(-16)
            make.trailing.equalTo(chatLabel.snp.trailing).offset(16)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(6)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-6)
        }
        timeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(boxView.snp.leading).offset(-8)
            make.bottom.equalTo(boxView.snp.bottom)
        }

    }
    
}
