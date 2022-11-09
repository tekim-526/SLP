//
//  UITextField+Extensions.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/09.
//

import UIKit

extension UITextField {
    func setDatePicker(target: Any, selector: Selector) {
        let datePicker: UIDatePicker = {
            let picker = UIDatePicker()
            picker.preferredDatePickerStyle = .wheels
            picker.datePickerMode = .date
            return picker
        }()
        datePicker.addTarget(target, action: selector, for: .valueChanged)
        self.inputView = datePicker
        
       
        
    }
}
