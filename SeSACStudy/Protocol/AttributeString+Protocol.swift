//
//  AttributeString+Protocol.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/09.
//

import UIKit

protocol AttributeString {
    func attributeString(first: String, second: String, firstSize: CGFloat, secondSize: CGFloat, firstColor: UIColor, secondColor: UIColor) -> NSMutableAttributedString
}

extension AttributeString {
    func attributeString(first: String, second: String, firstSize: CGFloat = CGFloat(24), secondSize: CGFloat = CGFloat(24), firstColor: UIColor = .brandGreen, secondColor: UIColor = .black) -> NSMutableAttributedString {
        let attributedTitle = NSMutableAttributedString(string: first, attributes: [NSAttributedString.Key.foregroundColor : firstColor, NSAttributedString.Key.font: UIFont(name: "NotoSansKR-Medium", size: firstSize)!])
        
        attributedTitle.append(NSAttributedString(string: second, attributes: [NSAttributedString.Key.foregroundColor : secondColor, NSAttributedString.Key.font: UIFont(name: "NotoSansKR-Regular", size: secondSize)!]))
        return attributedTitle
    }
}
