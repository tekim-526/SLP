//
//  ChatViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/29.
//

import UIKit

class ChatViewController: BaseViewController {
    var payloads: [Payload] = []
    let chatView = ChatView()
    var myQueueState: MyQueueState!

    var datasource: UICollectionViewDiffableDataSource<Int, Payload>!
    override func loadView() {
        view = chatView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchChat()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage), name: NSNotification.Name("getMessage"), object: nil)
        
        chatView.sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)

        setDatasource()
        let rightButton = UIBarButtonItem(title: "닷지", style: .plain, target: self, action: #selector(dodgeButtonTapped))
        
//        makeNavigationUI(title: myQueueState.matchedNick, rightBarButtonItem: rightButton)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTextView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
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
            switch response {
            case .success(let data):
                self?.refreshSnapshot(payload: data)
                self?.chatView.textView.text = nil
//                self?.chatView.textView.resignFirstResponder()
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
        
        refreshSnapshot(payload: Payload(id: id, to: to, from: from, chat: chat, createdAt: createdAt))
        
    }
    @objc func keyboardUp(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            UIView.animate(withDuration: 0.3) {
                self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height )
            }
        }
    }
    
    @objc func keyboardDown() {
        view.transform = .identity
    }
    
    func setDatasource() {
        let myCellReg = UICollectionView.CellRegistration<MyChatCell ,Payload> { cell, indexPath, itemIdentifier in  }
        let otherCellReg = UICollectionView.CellRegistration<OtherChatCell ,Payload> { cell, indexPath, itemIdentifier in  }
       
        datasource = UICollectionViewDiffableDataSource(collectionView: chatView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let foramtter = DateFormatter()
            foramtter.dateFormat = "H:mm"
            
            if itemIdentifier.from == "self?.myQueueState.matchedUid" {
                let cell = collectionView.dequeueConfiguredReusableCell(using: otherCellReg, for: indexPath, item: itemIdentifier)
                cell.chatLabel.text = itemIdentifier.chat
                //시간 보여주기 해야함
                return cell
            } else {
                let cell = collectionView.dequeueConfiguredReusableCell(using: myCellReg, for: indexPath, item: itemIdentifier)
                cell.chatLabel.text = itemIdentifier.chat
                //시간 보여주기 해야함
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
    }
    
    func setTextView() {
        chatView.textView.delegate = self
        chatView.textView.text = "메시지를 입력하세요"
        chatView.textView.textColor = .gray7
    }
    
    func fetchChat() {
        ChatAPIManager.shared.fetchChat(otheruid: myQueueState.matchedUid, lastchatDate: "2000-01-01T00:00:00.000Z") { [weak self] response in
            guard let vc = self else {return}
            switch response {
            case .success(let data):
                vc.payloads = data.payload
                
                var snapshot = NSDiffableDataSourceSnapshot<Int, Payload>()
                snapshot.appendSections([0])
                snapshot.appendItems(vc.payloads, toSection: 0)
                vc.datasource.apply(snapshot)
                vc.chatView.collectionView.scrollToItem(at: [0, vc.payloads.count - 1], at: .bottom, animated: false)
                SocketIOManager.shared.establishConnection()
                
            case .failure(let status):
                print("FetchFailed : \(status.localizedDescription)")
            }
        }
    }
    
    func refreshSnapshot(payload: Payload) {
        var snapshot = datasource.snapshot()
        snapshot.appendItems([payload])
        datasource.apply(snapshot)
        chatView.collectionView.scrollToItem(at: [0, datasource.snapshot(for: 0).items.count - 1], at: .bottom, animated: false)
    }
    
}

extension ChatViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if chatView.textView.text.isEmpty {
            chatView.textView.text = "메시지를 입력하세요."
            chatView.textView.textColor = .gray7
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !chatView.textView.text.isEmpty {
            chatView.textView.text = nil
            chatView.textView.textColor = .black
        }
    }
 
    func textViewDidChange(_ textView: UITextView) {
        var height = textView.contentSize.height

        if height > 60 {
            height = 72
        } else if height < 20 {
            height = 24
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
