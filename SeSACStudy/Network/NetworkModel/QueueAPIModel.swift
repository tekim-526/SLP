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
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.dodged = try container.decode(Int.self, forKey: .dodged)
        self.matched = try container.decode(Int.self, forKey: .matched)
        self.reviewed = try container.decode(Int.self, forKey: .reviewed)
        self.matchedNick = try container.decodeIfPresent(String.self, forKey: .matchedNick) ?? ""
        self.matchedUid = try container.decodeIfPresent(String.self, forKey: .matchedUid) ?? ""
    }
}
