//
//  WithdrawPopUpView.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/16.
//

import UIKit

class WithdrawPopUpView: BaseView {
    let title: UILabel = {
        let label = UILabel()
        label.text = "정말 탈퇴하시겠습니까?"
        label.font = UIFont(name: "NotoSansKR-Medium", size: 16)
        return label
    }()
    
    let subTitle: UILabel = {
        let label = UILabel()
        label.text = "탈퇴하시면 새싹 스터디를 이용할 수 없어요ㅠ"
        label.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        return label
    }()

    let okButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        button.backgroundColor = .brandGreen
        button.tintColor = .white
        button.layer.cornerRadius = 8
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        button.backgroundColor = .gray2
        button.tintColor = .black
        button.layer.cornerRadius = 8
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        self.layer.cornerRadius = 16
        self.layer.borderColor = UIColor.gray3.cgColor
        self.layer.borderWidth = 1
        [title, subTitle, okButton, cancelButton].forEach { self.addSubview($0) }
    }
    
    override func makeConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        let centerX = self.snp.centerX
        
        title.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(16)
            make.centerX.equalTo(centerX)
        }
        subTitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(8)
            make.centerX.equalTo(centerX)
        }
        okButton.snp.makeConstraints { make in
            make.top.equalTo(subTitle.snp.bottom).offset(16)
            make.leading.equalTo(cancelButton.snp.trailing).offset(8)
            make.bottom.trailing.equalTo(safeArea).offset(-16)
        }
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(subTitle.snp.bottom).offset(16)
            make.leading.equalTo(safeArea).offset(16)
            make.width.equalTo(152)
            make.bottom.equalTo(safeArea).offset(-16)
        }
    }

}
