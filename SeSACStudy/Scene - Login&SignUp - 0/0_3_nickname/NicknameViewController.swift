//
//  SignUpViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/09.
//

import UIKit

import RxCocoa
import RxSwift

class NicknameViewController: BaseViewController {
    let nicknameView = SignUpAndAuthView()
    let disposeBag = DisposeBag()
    
    let birthVC = BirthViewController()
    
    override func loadView() {
        view = nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nicknameView.textField.keyboardType = .default
        nicknameView.textField.becomeFirstResponder()
        bind()
    }
    
    func bind() {
        nicknameView.textField.rx.text
            .orEmpty
            .map { $0.count > 0 }
            .withUnretained(self)
            .subscribe { vc, bool in
                if bool {
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                        vc.nicknameView.lineView.backgroundColor = .black
                    }
                }
            } .disposed(by: disposeBag)
        
        nicknameView.textField.rx.text
            .orEmpty
            .map { $0.count > 0 && $0.count <= 10 }
            .withUnretained(self)
            .subscribe { vc, bool in
                vc.nicknameView.button.isEnabled = bool
                vc.nicknameView.button.backgroundColor = bool ? .brandGreen : .gray6
                vc.nicknameView.button.tintColor = bool ? .white : .gray3
            }.disposed(by: disposeBag)
        
        nicknameView.button.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                // tapEvent
                // 유효한 닉네임
                if true {
                    UserDefaults.standard.set(vc.nicknameView.textField.text!, forKey: "nick")
                    vc.navigationController?.pushViewController(vc.birthVC, animated: true)
                }
        }.disposed(by: disposeBag)
    }
    
    override func setupUI() {
        nicknameView.label.text = "닉네임을 입력해 주세요"
        nicknameView.textField.placeholder = "10자 이내로 입력"
        nicknameView.button.setTitle("다음", for: .normal)
    }
}
