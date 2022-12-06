//
//  ChatCRUD.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/12/05.
//

import Foundation
import RealmSwift

class ChatCRUD {
    let localRealm = try! Realm()
    
    func fetch() -> Results<RoomTable> {
        return localRealm.objects(RoomTable.self)
    }
    
    func addRoom(room: RoomTable, completion: () -> Void) {
        do {
            try localRealm.write {
                localRealm.add(room)
            }
        } catch {
            completion()
        }
    }
    
    func addChat(chat: ChatTable, completion: () -> Void) {
        do {
            try localRealm.write {
                localRealm.add(chat)
            }
        } catch {
            completion()
        }
    }
    
    func updateChatArray(room: RoomTable, chatArray: [ChatTable], completion: () ->Void) {
        do {
            try localRealm.write {
                room.chatArray = chatArray
            }
        } catch {
            completion()
        }
    }
    
    func fetchRoom(id: String) -> Results<RoomTable> {
        let url = localRealm.configuration.fileURL!
        print("🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟", url, "🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟🌟")
        return localRealm.objects(RoomTable.self).filter("otheruid == %@", id)
    }
    func fetchChat() {
        
    }
}
