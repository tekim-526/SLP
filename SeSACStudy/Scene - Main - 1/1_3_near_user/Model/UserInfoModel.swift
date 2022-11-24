//
//  UserInfoModel.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/24.
//

import Foundation

struct UserInfoModel: Hashable {
    let background: Int
    let reviews: [String]
    let nick: String
    let uid: String
    let studylist: [String]
    let sesac: Int
    let gender: Int
}
