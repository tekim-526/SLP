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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nearUserView.refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDatasource(personData: peopleData.fromQueueDB)
        if peopleData.fromQueueDB.isEmpty { return }
        checkDataisEmpty(bool: peopleData.fromQueueDB.isEmpty)
        
    }
    @objc override func refreshButtonTapped() {
        QueueAPIManager.shared.searchNearPeople(lat: pinLocation.lat, long: pinLocation.long) { [weak self] response in
            guard let vc = self else {return}
            switch response {
            case .success(let data):
                vc.peopleData = data
                vc.setDatasource(personData: data.fromQueueDB)
            case .failure(_):
                Toast.makeToast(view: vc.view, message: "데이터를 불러오는데 실패했습니다")
            }
        }
    }
    
}
