//
//  QueueAPIParameters.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/24.
//

import Foundation

struct NearPeople: Codable {
    let lat: Double
    let long: Double
}

struct NearPeopleWithStudy: Codable {
    let lat: Double
    let long: Double
    let studylist: [String]
}
