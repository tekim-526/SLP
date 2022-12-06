//
//  ChatViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/29.
//

import UIKit
import RealmSwift

class ChatViewController: BaseViewController {
    var payloads: [Payload] = []
    let chatView = ChatView()
    var myQueueState: MyQueueState!
    var datasource: UICollectionViewDiffableDataSource<Int, ChatTable>!
    var chatViewModel = ChatViewModel()
    
    private var chatCRUD = ChatCRUD()
    
    private var tasks: RoomTable?
    
    override func loadView() {
        view = chatView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasks = chatCRUD.fetchRoom(id: myQueueState.matchedUid).last
        guard tasks != nil else {
            chatCRUD.addRoom(room: RoomTable(otheruid: myQueueState.matchedUid, chatArray: [])) {
                Toast.makeToast(view: self.view, message: "채팅방을 만드는데 실패했습니다.")
            }
            return
        }

        setDatasource()
        guard let lastchatDate = tasks?.chatData.last?.createdAt.isEmpty ?? true ? "2000-01-01T00:00:00.000Z" : tasks?.chatData.last?.createdAt else {return}
        fetchChat(lastchatDate: lastchatDate)
        chatView.sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        let rightButton = UIBarButtonItem(title: "닷지", style: .plain, target: self, action: #selector(dodgeButtonTapped))
        makeNavigationUI(title: myQueueState.matchedNick, rightBarButtonItem: rightButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTextView()
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage), name: NSNotification.Name("getMessage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chatViewModel.keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("getMessage"), object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        SocketIOManager.shared.closeConnection()
    }
        
    @objc func dodgeButtonTapped() {
        guard let id = UserDefaults.standard.string(forKey: UserDefaultsKey.idtoken.rawValue) else { return }
        QueueAPIManager.shared.myStudy(idtoken: id, method: .dodge, otheruid: myQueueState.matchedUid) { [weak self] status in
            switch status {
            case .ok: self?.changeSceneToMain(vc: TabBarController(), isNav: false)
            default: self?.handleError(status: status)
            }
        }
    }
    
    @objc func sendButtonTapped() {
        ChatAPIManager.shared.sendChat(to: myQueueState.matchedUid, chat: chatView.textView.text) { [weak self] response in
            guard let vc = self else { return }
            switch response {
            case .success(let data):
                vc.addChat(id: data.id, to: data.to, from: data.from, chat: data.chat, createdAt: data.createdAt)
                vc.refreshSnapshot(datasource: vc.datasource, chatTable: ChatTable(id: data.id, to: data.to, from: data.from, chat: data.chat, createdAt: data.createdAt))
                vc.chatView.textView.text = nil
            case .failure(let status): print("inside closure and status \(status.rawValue)\n \(status.localizedDescription)")
            }
        }
    }
    
    @objc func getMessage(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let id = userInfo["_id"] as? String else { return }
        guard let to = userInfo["to"] as? String else { return }
        guard let from = userInfo["from"] as? String else { return }
        guard let chat = userInfo["chat"] as? String else { return }
        guard let createdAt = userInfo["createdAt"] as? String else { return }
        
        addChat(id: id, to: to, from: from, chat: chat, createdAt: createdAt)
        refreshSnapshot(datasource: datasource, chatTable: ChatTable(id: id, to: to, from: from, chat: chat, createdAt: createdAt))
    }
    
    @objc func keyboardUp(notification: Notification) {
        chatView.collectionView.scrollToItem(at: [0, datasource.snapshot(for: 0).items.count - 1], at: .bottom, animated: false)
    }
    
    @objc func keyboardDown() {
        chatView.collectionView.scrollToItem(at: [0, datasource.snapshot(for: 0).items.count - 1], at: .bottom, animated: false)
    }
    
    func setDatasource() {
        let myCellReg = UICollectionView.CellRegistration<MyChatCell ,ChatTable> { cell, indexPath, itemIdentifier in  }
        let otherCellReg = UICollectionView.CellRegistration<OtherChatCell ,ChatTable> { cell, indexPath, itemIdentifier in  }
       
        datasource = UICollectionViewDiffableDataSource(collectionView: chatView.collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            if itemIdentifier.from == self?.myQueueState.matchedUid {
                let cell = collectionView.dequeueConfiguredReusableCell(using: otherCellReg, for: indexPath, item: itemIdentifier)
                cell.chatLabel.text = itemIdentifier.chat
                cell.timeLabel.text = self?.chatViewModel.iso8601ToTimeAndMinute(dateString: itemIdentifier.createdAt)
                return cell
            } else {
                let cell = collectionView.dequeueConfiguredReusableCell(using: myCellReg, for: indexPath, item: itemIdentifier)
                cell.chatLabel.text = itemIdentifier.chat
                cell.timeLabel.text = self?.chatViewModel.iso8601ToTimeAndMinute(dateString: itemIdentifier.createdAt)
                return cell
            }
        })
        
        let header = UICollectionView.SupplementaryRegistration<ChatHeaderView>(elementKind: "chatHeader") { supplementaryView, elementKind, indexPath in  }
        
        datasource.supplementaryViewProvider = .some({ collectionView, elementKind, indexPath in
            let header = collectionView.dequeueConfiguredReusableSupplementary(using: header, for: indexPath)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.dateFormat = "M월 dd일 EEEE"
            header.dateLabel.text = dateFormatter.string(from: Date())
            return header
        })
        var snapshot = NSDiffableDataSourceSnapshot<Int, ChatTable>()
        snapshot.appendSections([0])
        datasource.apply(snapshot)
    }
    
    func setTextView() {
        chatView.textView.delegate = self
        chatView.textView.text = "메시지를 입력하세요"
        chatView.textView.textColor = .gray7
    }
    
    func fetchChat(lastchatDate: String) {
        ChatAPIManager.shared.fetchChat(otheruid: myQueueState.matchedUid, lastchatDate: lastchatDate) { [weak self] response in
            guard let vc = self else {return}
            switch response {
            case .success(let data):
                vc.payloads = data.payload
                guard let tasks = vc.tasks else {
                    return
                }
                let chatArray = vc.chatViewModel.payloadToChatArray(payload: data.payload)
                switch tasks.chatData.isEmpty {
                case true:
                    vc.chatCRUD.updateChatArray(room: tasks, chatArray: chatArray) {
                        Toast.makeToast(view: vc.view, message: "채팅을 불러오는데 실패 했습니다")
                    }
                case false:
                    vc.chatCRUD.addChats(room: tasks, chats: chatArray) {
                        Toast.makeToast(view: vc.view, message: "채팅을 불러오는데 실패 했습니다")
                    }
                }
                var snapshot = vc.datasource.snapshot()
                snapshot.appendItems(tasks.chatArray)
                vc.datasource.apply(snapshot)
                vc.chatView.collectionView.scrollToItem(at: [0, tasks.chatArray.count - 1], at: .bottom, animated: false)
                SocketIOManager.shared.establishConnection()
            case .failure(let status):
                print("FetchFailed : \(status.localizedDescription)")
            }
        }
    }
    
    func refreshSnapshot(datasource: UICollectionViewDiffableDataSource<Int, ChatTable>, chatTable: ChatTable) {
        var snapshot = datasource.snapshot()
        snapshot.appendItems([chatTable])
        datasource.apply(snapshot)
        chatView.collectionView.scrollToItem(at: [0, datasource.snapshot(for: 0).items.count - 1], at: .bottom, animated: false)
    }
    
    func addChat(id: String, to: String, from: String, chat: String, createdAt: String) {
        guard let tasks else {return}
        chatCRUD.addChats(room: tasks, chats: [ChatTable(id: id, to: to, from: from, chat: chat, createdAt: createdAt)]) {
            Toast.makeToast(view: view, message: "채팅 불러오기 실패")
        }
    }
}

extension ChatViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "메시지를 입력하세요."
            textView.textColor = .gray7
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !textView.text.isEmpty {
            textView.text = nil
            textView.textColor = .black
        }
    }
 
    func textViewDidChange(_ textView: UITextView) {
        var height = textView.contentSize.height
        if height > 60 {
            height = 72
        } else if height < 20 {
            height = 24
        }
        print(height)
        if textView.text.count > 0 {
            chatView.sendButton.setImage(UIImage(named: "SendButton.fill"), for: .normal)
            chatView.sendButton.isUserInteractionEnabled = true
        } else {
            chatView.sendButton.setImage(UIImage(named: "SendButton"), for: .normal)
            chatView.sendButton.isUserInteractionEnabled = false
        }

        textView.snp.remakeConstraints { make in
            make.leading.equalTo(chatView.sendView.safeAreaLayoutGuide).offset(12)
            make.top.equalTo(chatView.sendView.snp.top).offset(8)
            make.height.greaterThanOrEqualTo(height)
            make.bottom.equalTo(chatView.sendView.snp.bottom).offset(-8)
            make.trailing.equalTo(chatView.sendButton.snp.leading).offset(-12)
        }
        
        self.view.layoutIfNeeded()
    }
}

