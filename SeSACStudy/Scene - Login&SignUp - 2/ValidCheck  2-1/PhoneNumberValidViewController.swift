//
//  InputPhoneNumberViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift

class PhoneNumberValidViewController: BaseViewController {
    let validView = SignUpAndAuthView()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = validView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        validView.textField.delegate = self
        validView.button.addTarget(self, action: #selector(getButtonTapped), for: .touchUpInside)
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
            
        
        //valid check
        validView.textField.rx.text
            .orEmpty
            .map { self.phoneValid(number: $0) }
            .withUnretained(self)
            .subscribe { vc, bool in
                vc.validView.button.isEnabled = bool
                vc.validView.button.backgroundColor = bool ? .brandGreen : .gray6
                vc.validView.button.tintColor = bool ? .white : .gray3
            }.disposed(by: disposeBag)
    }
    
    override func setupUI() {
        validView.label.text = "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요"
        validView.textField.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
    }
    
    func phoneValid(number: String) -> Bool {
        let pattern = "^01([0-9])-([0-9]{3,4})-([0-9]{4})$"
        let regex = try? NSRegularExpression(pattern: pattern)
        if let _ = regex?.firstMatch(in: number, options: [], range: NSRange(location: 0, length: number.count)) {
            return true
        } else {
            return false
        }
    }
    
    @objc func getButtonTapped() {
        print("인증 문자 받기 버튼 tapped!")
    }
    
    func phoneNumberFormat(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
        guard !phoneNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")

        if number.count > 11 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 11)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }

        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<end])
        }

        if number.count < 7 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "$1-$2", options: .regularExpression, range: range)
        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            
            if number.count <= 10{
                number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "$1-$2-$3", options: .regularExpression, range: range)
            } else if number.count == 11 {
                number = number.replacingOccurrences(of: "(\\d{3})(\\d{4})(\\d+)", with: "$1-$2-$3", options: .regularExpression, range: range)
            }
        }
        return number
    }
    
    
}

extension PhoneNumberValidViewController: UITextFieldDelegate {
    // Rx로 수정하장
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var fullString = textField.text ?? ""
        fullString.append(string)
        
        if string.isEmpty || string >= "0" && string <= "9" || string == "-" {
            if range.length == 1 { // 지우기 (하이픈까지 지워버림)
                textField.text = phoneNumberFormat(phoneNumber: fullString, shouldRemoveLastDigit: true)
            } else { // 입력하기
                textField.text = phoneNumberFormat(phoneNumber: fullString)
            }
        } else { return false }
        
        return false
    }
}

