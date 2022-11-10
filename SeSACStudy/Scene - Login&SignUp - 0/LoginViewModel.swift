//
//  PhoneNumberViewModel.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/10.
//

import Foundation

class LoginViewModel {
    func phoneValid(number: String) -> Bool {
        let pattern = "^01([0-9])-?([0-9]{3,4})-?([0-9]{4})$"
        let regex = try? NSRegularExpression(pattern: pattern)
        if let _ = regex?.firstMatch(in: number, options: [], range: NSRange(location: 0, length: number.count)) {
            return true
        } else {
            return false
        }
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
    
    func ageCalculate(birth: Date) -> Int {
        let format = DateFormatter()
        format.dateFormat = "yyyy MM dd"
        
        let birth = format.string(from: birth).split(separator: " ").map{Int(String($0))!}
        let today = format.string(from: Date()).split(separator: " ").map{Int(String($0))!}

        var yearGlobal: Int = 0 // 만 나이

        if today[0] > birth[0] { // 년 지났을 때,
            if today[1] > birth[1] { // 월 지났을 때,
                yearGlobal = today[0] - birth[0]
            }
            else if today[1] < birth[1] { // 월 안 지났을 때,
                yearGlobal = today[0] - birth[0] - 1
            }
            else { // 월 같을 때,
                if today[2] >= birth[2] { // 일 같거나 지났을 때,
                    yearGlobal = today[0] - birth[0]
                }
                else { // 일 안 지났으면,
                    yearGlobal = today[0] - birth[0] - 1
                }
            }
        }
        else { // 연도가 같으면,
            yearGlobal = 0 // 만 나이는 0살
        }
        return yearGlobal
    }
}
