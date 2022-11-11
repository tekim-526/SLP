//
//  InputPhoneNumberViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift

import FirebaseAuth

class PhoneNumberValidViewController: BaseViewController {
    let validView = SignUpAndAuthView()
    
    let disposeBag = DisposeBag()
    let authVC = AuthNumberViewController()
    let viewModel = LoginViewModel()
    
    override func loadView() {
        view = validView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIManager.shared.login(idtoken: UserDefaults.standard.string(forKey: "idtoken") ?? "")
        APIManager.shared.signup(idtoken: UserDefaults.standard.string(forKey: "idtoken") ?? "")
        bind()
    }
    
    func bind() {
        // color Change
        validView.textField.rx.controlEvent(.touchDown)
            .withUnretained(self)
            .subscribe { vc, _ in
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                    vc.validView.lineView.backgroundColor = .black
                }
            } .disposed(by: disposeBag)
        
        validView.textField.rx.text
            .orEmpty
            .map { str in
                if !str.isEmpty {
                    let lastIndex = str.index(before: str.endIndex)
                    let tmp = String(str[lastIndex])
                    return tmp.isEmpty || tmp >= "0" && tmp <= "9" || tmp == "-"
                }
                return str.count <= 13
            }
            .withUnretained(self)
            .bind { vc, bool in
                if !bool {
                    vc.validView.textField.text = ""
                    vc.showAlert(title: "값이 유효하지 않습니다.", message: "숫자만 입력해주세요")
                }
            }.disposed(by: disposeBag)
        
        validView.textField.rx.text
            .orEmpty
            .withUnretained(self)
            .map { vc, str in
                if !str.isEmpty {
                    let lastIndex = str.index(before: str.endIndex)
                    let tmp = String(str[lastIndex])
                    if tmp.isEmpty || tmp >= "0" && tmp <= "9" || tmp == "-" {
                        if tmp == "" { // 지우기 (하이픈까지 지워버림)
                            vc.validView.textField.text = vc.viewModel.phoneNumberFormat(phoneNumber: str, shouldRemoveLastDigit: true)
                        } else { // 입력하기
                            vc.validView.textField.text = vc.viewModel.phoneNumberFormat(phoneNumber: str)
                        }
                    }
                }
                return self.validView.textField.text!
            }
            .map { self.viewModel.phoneValid(number: $0) }
            .withUnretained(self)
            .bind { vc, bool in
                vc.validView.button.isEnabled = bool
                vc.validView.button.backgroundColor = bool ? .brandGreen : .gray6
                vc.validView.button.tintColor = bool ? .white : .gray3
            }.disposed(by: disposeBag)
        
        
        validView.button.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                // MARK: - 문자 받는 메서드 설정 해야함
                if true {
                    let number = vc.validView.textField.text!
                    var removeDash = number.split(separator: "-").reduce(into: "") { $0 += $1 }
                    removeDash.removeFirst()
                    let realPhoneNumber = "+82\(removeDash)"
                    print(realPhoneNumber)
                    AuthManager.shared.startAuth(phoneNumber: realPhoneNumber) { success in
                        guard success else { return }
                        print("success")
                        DispatchQueue.main.async {
                            UserDefaults.standard.set(realPhoneNumber, forKey: "phoneNumber")
                            vc.navigationController?.pushViewController(vc.authVC, animated: true)
                        }
                    }
                }
            }.disposed(by: disposeBag)
        
    }
    override func setupUI() {
        validView.label.text = "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요"
        validView.textField.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
    }
    
    
    
}


