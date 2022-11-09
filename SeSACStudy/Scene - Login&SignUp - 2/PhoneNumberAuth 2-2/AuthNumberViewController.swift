//
//  AuthNumberViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit

class AuthNumberViewController: BaseViewController {
    let authView = SignUpAndAuthView()
    
    let disposeBag = DisposeBag()
    
    let resendButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .brandGreen
        button.setTitle("재전송", for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func loadView() {
        view = authView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authView.textField.delegate = self
        bind()
    }
    func bind() {
        authView.textField.rx.text
            .orEmpty
            .map { $0.count == 6 }
            .withUnretained(self)
            .bind { vc, bool in
                vc.authView.button.backgroundColor = bool ? .brandGreen : .gray6
                vc.authView.button.tintColor = bool ? .white : .gray3
                vc.authView.button.isEnabled = bool
            }
            .disposed(by: disposeBag)
        
        authView.button.rx.tap.bind {
            // tapEvent
            // 회원일때 -> 회원가입
            // 회원 아닐때 -> 홈 화면
            print(123)
        }.disposed(by: disposeBag)
    }
    override func setupUI() {
        view.addSubview(resendButton)
        authView.label.text = "인증번호가 문자로 전송되었어요"
        authView.textField.placeholder = "인증번호 입력"
        authView.button.setTitle("인증하고 시작하기", for: .normal)
    }
    
    override func makeConstraints() {
        resendButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.centerY.equalTo(authView.textField.snp.centerY)
            make.width.equalTo(72)
            make.height.equalTo(40)
        }
        authView.lineView.snp.remakeConstraints { make in
            make.top.equalTo(authView.textField.snp.bottom)
            make.height.equalTo(1)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-96)
        }
    }
}

extension AuthNumberViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty || string >= "0" && string <= "9" {
            let newLength = (textField.text?.count)! + string.count - range.length
            return !(newLength > 6)
        } else {
            return false
        }
    }
}
