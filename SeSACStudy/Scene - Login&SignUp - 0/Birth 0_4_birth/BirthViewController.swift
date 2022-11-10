//
//  BirthViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/09.
//

import UIKit

import RxSwift
import RxCocoa

class BirthViewController: BaseViewController {
    let birthView = BirthView()
    let disposeBag = DisposeBag()
    let emailVC = EmailViewController()
    
    let viewModel = LoginViewModel()
    
    var birth = Date()
    
    let tempTextField = UITextField()
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .date
        return picker
    }()
    
    override func loadView() {
        view = birthView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTempTextField()
        bind()
        
        
    }
    
    func bind() {
        birthView.button.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                // 나이 체크 로직
                // tapEvent
                // 회원일때 -> 회원가입
                let age = vc.viewModel.ageCalculate(birth: vc.birth)
                if age >= 17 {
                    let format = DateFormatter()
                    format.dateFormat = "yyyy-MM-dd"
                    UserDefaults.standard.set(format.string(from: vc.birth)+"T08:30:20.000Z", forKey: "birth")
                    
                    vc.navigationController?.pushViewController(vc.emailVC, animated: true)
                } else {
                    vc.showAlert(title: "만 17세 미만은 사용할 수 없습니다.", message: "강해져서 돌아와라")
                }
                // 회원 아닐때 -> 홈 화면
                
            }.disposed(by: disposeBag)
        
    }
    
    @objc func pickerValueChanged(sender: UIDatePicker) {
        let year = DateFormatter()
        year.dateFormat = "yyyy"
        birthView.yearTextField.text = year.string(from: sender.date)
        let month = DateFormatter()
        month.dateFormat = "MM"
        birthView.monthTextField.text = month.string(from: sender.date)
        let day = DateFormatter()
        day.dateFormat = "dd"
        birthView.dayTextField.text = day.string(from: sender.date)
        
        birthView.button.isEnabled = true
        birthView.button.tintColor = .white
        birthView.button.backgroundColor = .brandGreen
        birth = sender.date
        
        
    }
    func setTempTextField() {
        view.addSubview(tempTextField)
        tempTextField.becomeFirstResponder()
        tempTextField.tintColor = .clear
        tempTextField.setDatePicker(target: self, selector: #selector(pickerValueChanged))
       
    }
    
    
}

