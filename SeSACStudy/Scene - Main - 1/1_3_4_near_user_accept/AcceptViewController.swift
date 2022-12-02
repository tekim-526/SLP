//
//  ReceivedRequestViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/23.
//

import UIKit

class AcceptViewController: BaseRequestAndAccpetViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkDataisEmpty(bool: peopleData.fromQueueDBRequested.isEmpty)
        if peopleData.fromQueueDBRequested.isEmpty { return }
        setDatasource(personData: peopleData.fromQueueDBRequested)
    }
    
    override func insideImageButtonTapped(_ sender: UIButton) {
        guard let id = UserDefaults.standard.string(forKey: UserDefaultsKey.idtoken.rawValue) else { return }
        print("sender.tag :", sender.tag)
        let otheruid = peopleData.fromQueueDBRequested[sender.tag].uid
        QueueAPIManager.shared.myStudy(idtoken: id, method: .studyaccept, otheruid: otheruid) { [weak self] status in
            switch status {
            case .ok: // 채팅창으로 이동 원래는 팝업띄우고 해야함
                self?.presentChatView()
            case .created: Toast.makeToast(view: self?.view, message: "상대방이 이미 다른 새싹과 스터디를 함께 하는 중입니다")
            case .accepted: Toast.makeToast(view: self?.view, message: "상대방이 스터디 찾기를 그만두었습니다")
            case .nonAuthoritativeInformation: Toast.makeToast(view: self?.view, message: "앗! 누군가가 나의 스터디를 수락하였어요!")
            default:
                self?.handleError(status: status)
                
            }
        }
    }
    func presentChatView() {
        QueueAPIManager.shared.myQueueState { [weak self] response in
            switch response {
            case .success(let success):
                let vc = ChatViewController()
                vc.myQueueState = success
                self?.present(vc, animated: true)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
