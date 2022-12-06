//
//  ChatViewModel.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/12/06.
//

import Foundation

class ChatViewModel {
    func payloadToChatArray(payload: [Payload]) -> [ChatTable] {
        var chatTable = [ChatTable]()
        for item in payload {
            chatTable.append(ChatTable(id: item.id, to: item.to, from: item.from, chat: item.chat, createdAt: item.createdAt))
        }
        return chatTable
    }
    
    func iso8601ToTimeAndMinute(dateString: String) -> String {
        let stringToDateFormatter = DateFormatter()
        stringToDateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSSZ"
              
        let dateToStringForamtter = DateFormatter()
        dateToStringForamtter.dateFormat = "H:mm"
        
        let date = stringToDateFormatter.date(from: dateString)
        
        return dateToStringForamtter.string(from: date ?? Date())
    }
    
    @objc func keyboardDown() {

    }
}
