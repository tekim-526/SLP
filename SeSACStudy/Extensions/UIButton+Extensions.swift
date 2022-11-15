//
//  UIButton+Extensions.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/15.
//

import UIKit

extension UIButton {
    func customButtonInMyInfo(title: String) -> UIButton {
        let button = UIButton()
        let attrstr = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont(name: "NotoSansKR-Regular", size: 14)!])
        button.setAttributedTitle(attrstr, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray2.cgColor
        return button
    }
    func customGenderSelectButtonInMyInfo(genderTitle: String) -> UIButton {
        let button = UIButton()
        let attrstr = NSAttributedString(string: genderTitle, attributes: [NSAttributedString.Key.font : UIFont(name: "NotoSansKR-Regular", size: 14)!])
        button.setAttributedTitle(attrstr, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray2.cgColor
        return button
    }
}
