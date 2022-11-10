//
//  InputPhoneNumber.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/08.
//

import UIKit

import SnapKit
import TextFieldEffects

class SignUpAndAuthView: BaseView {
    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        //label.text = "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요"
        label.font = UIFont(name: "NotoSansKR-Regular", size: 20)!
        return label
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        //tf.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        tf.tintColor = .gray7
        tf.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        tf.keyboardType = .numberPad
        return tf
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("인증 문자 받기", for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        button.backgroundColor = .gray6
        button.tintColor = .gray3
        button.layer.cornerRadius = 8
        button.isEnabled = false
        return button
    }()
    
    let lineView: UIView = {
        let line = UIView()
        line.backgroundColor = .gray3
        return line
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        [label, textField, button, lineView].forEach { self.addSubview($0) }
        self.backgroundColor = .white
    }
    
    override func makeConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(125)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(64)
            make.height.equalTo(48)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(28)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-28)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.height.equalTo(1)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(72)
            make.height.equalTo(48)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
        }
    }
    
}


