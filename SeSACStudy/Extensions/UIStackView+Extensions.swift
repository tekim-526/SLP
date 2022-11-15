//
//  UIStackView+Extensions.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/15.
//

import UIKit

extension UIStackView {
    func makeStackView(axis: NSLayoutConstraint.Axis, isHidden: Bool = false, _ views: UIView...) -> UIStackView {
        let stackView = UIStackView()
        for view in views {
            stackView.addArrangedSubview(view)
        }
        stackView.spacing = 8
        stackView.axis = axis
        stackView.distribution = .fillEqually
        stackView.isHidden = isHidden
        return stackView
    }
    
}
