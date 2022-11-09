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
            .bind {
                // 나이 체크 로직
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
        
    }
    func setTempTextField() {
        view.addSubview(tempTextField)
        tempTextField.becomeFirstResponder()
        tempTextField.tintColor = .clear
        tempTextField.setDatePicker(target: self, selector: #selector(pickerValueChanged))
       
    }
}

