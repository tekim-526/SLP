//
//  StudyModel.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/18.
//

import Foundation

struct StudyModel: Hashable {
    let uuid: UUID
    let studyName: String
    let isRecommand: Bool
    init(_ studyName: String, isRecommand: Bool = false) {
        self.uuid = UUID()
        self.studyName = studyName
        self.isRecommand = isRecommand
    }
    
}
