//
//  ChatTable.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/12/05.
//

import Foundation
import RealmSwift

class RoomTable: Object {
    @Persisted(primaryKey: true) var otheruid: String
    @Persisted var chatData: List<ChatTable> = List<ChatTable>()
    
    var chatArray: [ChatTable] {
        get {
            return chatData.map { $0 }
        } set {
            chatData.removeAll()
            chatData.append(objectsIn: newValue)
            
        }
    }
    convenience init(otheruid: String, chatArray: [ChatTable]) {
        self.init()
        self.otheruid = otheruid
        self.chatArray = chatArray
    }
}

class ChatTable: Object {
    @Persisted var createdAt: String
    
    @Persisted var id: String
    @Persisted var to: String
    @Persisted var from: String
    @Persisted var chat: String
    convenience init(id: String, to: String, from: String,  chat: String, createdAt: String) {
        self.init()
        self.createdAt = createdAt
        self.id = id
        self.to = to
        self.chat = chat
        self.from = from
    }
}
