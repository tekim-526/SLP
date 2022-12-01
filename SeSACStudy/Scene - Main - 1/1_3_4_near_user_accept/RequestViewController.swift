//
//  NearUserViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/28.
//

import Foundation

enum MyQueueStatus: Int {
    case matching = 0
    case matched
    case stable
}

class RequestViewController: BaseRequestAndAccpetViewController {
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkMyState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDatasource(personData: peopleData.fromQueueDB)
        if peopleData.fromQueueDB.isEmpty { return }
        checkDataisEmpty(bool: peopleData.fromQueueDB.isEmpty)
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(stateCheck), userInfo: nil, repeats: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    func checkMyState() {
        
        QueueAPIManager.shared.myQueueState { [weak self] response in
//            print("request")
            switch response {
            case .success(let data):
                if data.matched == MyQueueStatus.matched.rawValue {
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
   
    @objc func stateCheck() {
        checkMyState()
    }
}
