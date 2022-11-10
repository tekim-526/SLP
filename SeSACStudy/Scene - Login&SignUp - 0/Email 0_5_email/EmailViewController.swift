//
//  EmailViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/09.
//

import UIKit

import RxCocoa
import RxSwift

class EmailViewController: BaseViewController, AttributeString {
    
    let emailView = SignUpAndAuthView()
    let disposeBag = DisposeBag()
    let genderView = GenderViewController()
    override func loadView() {
        view = emailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    func bind() {
        emailView.textField.rx.text
            .orEmpty
            .map { self.checkEmailValid(str: $0) }
            .withUnretained(self)
            .bind { vc, bool in
                print(bool)
                vc.emailView.button.isEnabled = bool
                vc.emailView.button.backgroundColor = bool ? .brandGreen : .gray6
                vc.emailView.button.tintColor = bool ? .white : .gray3
            }.disposed(by: disposeBag)
        
        emailView.button.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                UserDefaults.standard.set(vc.emailView.textField.text!, forKey: "email")
                vc.navigationController?.pushViewController(vc.genderView, animated: true)
            }.disposed(by: disposeBag)
    }
    override func setupUI() {
        emailView.label.attributedText = setupAttributeString()
        emailView.label.textAlignment = .center
        
        emailView.button.setTitle("다음", for: .normal)
        emailView.textField.placeholder = "SeSAC@email.com"
        emailView.textField.keyboardType = .default
    }
    
    func setupAttributeString() -> NSAttributedString {
        let attrStr = attributeString(first: "이메일을 입력해주세요\n", second: "휴대폰 번호 변경 시 인증을 위해 사용해요", firstSize: 20, secondSize: 16, firstColor: .black, secondColor: .gray7)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        attrStr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrStr.length))
        return attrStr
    }
    
    func checkEmailValid(str: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return  NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: str)
    }
}
