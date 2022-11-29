//
//  UserAPIModel.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/24.
//

import Foundation

struct MyPage: Codable {
    let searchable: Int
    let ageMin: Int
    let ageMax: Int
    let gender: Int
    let study: String
}

struct SignUp: Codable {
    let phoneNumber: String
    let FCMtoken: String
    let nick: String
    let birth: String
    let email: String
    let gender: Int
}
