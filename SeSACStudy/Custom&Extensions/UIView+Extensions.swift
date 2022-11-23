//
//  UITextField+Extensions.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/09.
//

import UIKit
import SnapKit

extension UIView {
    
    func yearMonthDayView(textField: UITextField, label: UILabel) -> UIView {
        let view = UIView()
        
        let lineView: UIView = {
            let v = UIView()
            v.backgroundColor = .gray3
            return v
        }()
        
        
        [textField, label, lineView].forEach { view.addSubview($0) }
       
        view.addSubview(textField)
        view.addSubview(label)
        view.addSubview(lineView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        label.snp.makeConstraints { make in
            make.top.equalTo(safeArea)
            make.trailing.equalTo(safeArea)
            make.bottom.equalTo(safeArea)
            make.width.equalTo(label.snp.height)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(safeArea)
            make.leading.leading.equalTo(safeArea)
            make.trailing.equalTo(label.snp.leading).offset(-4)
            make.bottom.equalTo(safeArea)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.height.equalTo(1)
            make.leading.equalTo(textField.snp.leading).offset(12)
            make.trailing.equalTo(textField.snp.trailing)
        }
        
        
        
        return view
    }
    
    
    
    
}
