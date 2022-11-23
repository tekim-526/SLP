//
//  UIStackView+Extensions.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/15.
//

import UIKit

extension UIStackView {
    func makeStackView(axis: NSLayoutConstraint.Axis, isHidden: Bool = false, spacing: CGFloat = 8, distribution: Distribution = .fillEqually, _ views: UIView...) -> UIStackView {
        let stackView = UIStackView()
        for view in views {
            stackView.addArrangedSubview(view)
        }
        stackView.spacing = spacing
        stackView.axis = axis
        
        stackView.distribution = distribution
        stackView.isHidden = isHidden
        return stackView
    }
    
}
