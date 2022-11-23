//
//  NearPeopleSearchModel.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/18.
//

import Foundation

struct GetNearPeopleData: Codable {
    let fromRecommend: [String]
    let fromQueueDB: [FromQueueDB]
}

// MARK: - FromQueueDB
struct FromQueueDB: Codable {
    let background: Int
    let reviews: [String]
    let type: Int
    let nick: String
    let long: Double
    let uid: String
    let studylist: [String]
    let sesac, gender: Int
    let lat: Double
    let reputation: [Int]
}
