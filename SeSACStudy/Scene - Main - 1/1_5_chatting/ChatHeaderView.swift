//
//  ChatHeaderView.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/30.
//

import UIKit

class ChatHeaderView: UICollectionReusableView {
    let dateView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray7
        view.layer.cornerRadius = 12
        return view
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NotoSansKR-Regular", size: 12)
        label.backgroundColor = .gray7
        label.textColor = .white
        label.layer.cornerRadius = 20
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
        [dateView, dateLabel].forEach { addSubview($0) }
    }
    
    func makeConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.centerX.equalTo(snp.centerX)
        }
        dateView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.top).offset(-4)
            make.bottom.equalTo(dateLabel.snp.bottom).offset(6)
            make.leading.equalTo(dateLabel.snp.leading).offset(-16)
            make.trailing.equalTo(dateLabel.snp.trailing).offset(16)
        }
        
    }
}
