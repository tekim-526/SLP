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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDatasource(personData: peopleData.fromQueueDB)
        if peopleData.fromQueueDB.isEmpty { return }
        checkDataisEmpty(bool: peopleData.fromQueueDB.isEmpty)
        
    }
    
    
}
