//
//  NetworkModel.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/16.
//

import Foundation

// backgroundImage, sesacImage, nickName, sesacTitle, review, gender, 자주하는 스터디, 내번호 검색 허용, age
struct MyInFoData: Codable {
    var background: Int
    var sesac:Int
    let nick: String
    let reputation: [Int]
    //let comment: [String]
    var gender: Int
    var study: String
    var searchable: Int
    var ageMin: Int
    var ageMax: Int
    var uid: String
}



