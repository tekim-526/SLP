//
//  QueueAPIModel.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/29.
//

import Foundation

struct MyQueueState: Codable {
    let dodged, matched, reviewed: Int
    let matchedNick, matchedUid: String
}
