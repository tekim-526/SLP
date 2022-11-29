//
//  NearUserViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/28.
//

import Foundation

class RequestViewController: BaseRequestAndAccpetViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        checkMyState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDatasource(personData: peopleData.fromQueueDB)
        if peopleData.fromQueueDB.isEmpty { return }
        checkDataisEmpty(bool: peopleData.fromQueueDB.isEmpty)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    func checkMyState() {
        QueueAPIManager.shared.myQueueState { [weak self] response in
            switch response {
            case .success(let data):
                if data.matched == 0 {
                    DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 5) {
                        self?.checkMyState()
                    }
                } else {
                    Toast.makeToast(view: self?.view, message: "\(data.matchedNick)님과 매칭되셨습니다.")
                }
            case .failure(let status):
                switch status {
                case .unauthorized: TokenManager.shared.getIdToken { _ in self?.checkMyState()}
                case .notAcceptable: self?.changeSceneToMain(vc: OnBoardingViewController())
                case .internalServerError: Toast.makeToast(view: self?.view, message: "500 Server Error")
                case .notImplemented: Toast.makeToast(view: self?.view, message: "501 Client Error")
                default: Toast.makeToast(view: self?.view, message: status.localizedDescription)
                }
            }
        }
    }
}
