//
//  Color.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/07.
//

import UIKit

extension UIColor {

    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(a) / 255.0)
    }

 

    convenience init(rgb: Int) {
           self.init(red: (rgb >> 16) & 0xFF, green: (rgb >> 8) & 0xFF, blue: rgb & 0xFF)
       }

    
    convenience init(argb: Int) {
        self.init(red: (argb >> 16) & 0xFF, green: (argb >> 8) & 0xFF, blue: argb & 0xFF, a: (argb >> 24) & 0xFF)
    }

}

extension UIColor {
    static let brandGreen = UIColor(rgb: 0x49DC92)
    static let brandWhiteGreen = UIColor(rgb: 0xCDF4E1)
    static let brandYellowGreen = UIColor(rgb: 0xB2EB61)
    
    static let systemSuccess = UIColor(rgb: 0x628FE5)
    static let systemError = UIColor(rgb: 0xE9666B)
    static let systemFocus = UIColor(rgb: 0x333333)
    
    static let gray7 = UIColor(rgb: 0x888888)
    static let gray6 = UIColor(rgb: 0xAAAAAA)
    static let gray5 = UIColor(rgb: 0xBDBDBD)
    static let gray4 = UIColor(rgb: 0xD1D1D1)
    static let gray3 = UIColor(rgb: 0xE2E2E2)
    static let gray2 = UIColor(rgb: 0xEFEFEF)
    static let gray1 = UIColor(rgb: 0xF7F7F7)
}

