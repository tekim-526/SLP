//
//  SocketIOManager.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/29.
//

import Foundation

import SocketIO

class SocketIOManager {
    static let shared = SocketIOManager()
    
    var manager: SocketManager!
    var socket: SocketIOClient!
    private init() {
        
        guard let uid = UserDefaults.standard.string(forKey: UserDefaultsKey.uid.rawValue) else { return }
        print("😀myuid <inside socketmanager :", uid)
        manager = SocketManager(socketURL: URL(string: "http://api.sesac.co.kr:1210")!, config: [.log(true), .compress, .forceWebsockets(true)])
        socket = manager.defaultSocket
        
        // 연결
        socket.on(clientEvent: .connect) { data, ack in
            print("😀CONNECT", data, ack)
            print("Socket is connected", data, ack)
            
            self.socket.emit("changesocketid", uid)
        }
        
        //연결 해제
        socket.on(clientEvent: .disconnect) { data, ack in
            print("😀DISCONNECT", data, ack)
        }
        
        // 이벤트 수신
        socket.on("chat") { dataArray, ack in
            print("😀SESAC RECEIVED", dataArray, ack)

            let data = dataArray[0] as! NSDictionary
            let id = data["_id"] as! String
            let to = data["to"] as! String
            let from = data["from"] as! String
            let chat = data["chat"] as! String
            let createdAt = data["createdAt"] as! String
            
            print("CHECK >>>", to, from, chat, createdAt)
            NotificationCenter.default.post(name: NSNotification.Name("getMessage"), object: self, userInfo: ["_id" : id,
                                                                                                              "to": to,
                                                                                                              "from": from,
                                                                                                              "chat": chat,
                                                                                                              "createdAt": createdAt
                                                                                                             ])
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
}
