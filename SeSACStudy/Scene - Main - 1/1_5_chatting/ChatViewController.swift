//
//  ChatViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/29.
//

import UIKit

class ChatViewController: BaseViewController {
    var chatData: [Payload] = []
    let chatView = ChatView()
    var otheruid: String!
    override func loadView() {
        view = chatView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChatAPIManager.shared.fetchChat(otheruid: otheruid, lastchatDate: "2000-01-01T00:00:00.000Z") { [weak self] response in
            switch response {
            case .success(let data):
                self?.chatData = data.payload
                print(200)
                SocketIOManager.shared.establishConnection()
            case .failure(let status):
                print("FetchFailed : \(status.localizedDescription)")
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage), name: NSNotification.Name("getMessage"), object: nil)
        chatView.sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        print(chatData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ChatAPIManager.shared.fetchChat(otheruid: otheruid, lastchatDate: "2000-01-01T00:00:00.000Z") { [weak self] response in
            switch response {
            case .success(let data):
                self?.chatData = data.payload
                print(200)
                SocketIOManager.shared.establishConnection()
            case .failure(let status):
                print("FetchFailed : \(status.localizedDescription)")
            }
        }
        chatView.sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        print(chatData)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SocketIOManager.shared.closeConnection()
    }
    
    @objc func sendButtonTapped() {
        print("sendButtonTapped!")
        ChatAPIManager.shared.sendChat(to: otheruid, chat: chatView.textView.text) { response in
            switch response {
            case .success(let data):
                dump(data)
            case .failure(let status): print("inside closure and status \(status.rawValue)\n \(status.localizedDescription)")
            }
        }
    }
    
    
    @objc func getMessage(notification: NSNotification) {
        print("😀",#function)
        print("😀", notification.userInfo!)
        guard let userInfo = notification.userInfo else { return }
        guard let id = userInfo["_id"] as? String else { return }
        guard let to = userInfo["to"] as? String else { return }
        guard let from = userInfo["from"] as? String else { return }
        guard let chat = userInfo["chat"] as? String else { return }
        guard let createdAt = userInfo["createdAt"] as? String else { return }
     
        let payload = Payload(id: id, to: to, from: from, chat: chat, createdAt: createdAt)
        chatData.append(payload)
    }
}
