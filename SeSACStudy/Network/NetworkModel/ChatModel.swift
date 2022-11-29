//
//  ChatModel.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/29.
//

import Foundation

// MARK: - ChatData
struct ChatData: Codable {
    let payload: [Payload]
}

// MARK: - Payload
struct Payload: Codable {
    let id: String
    let to, from, chat: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case to, from, chat, createdAt
    }
}
