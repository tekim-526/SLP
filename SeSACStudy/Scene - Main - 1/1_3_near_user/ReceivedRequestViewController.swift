//
//  ReceivedRequestViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/23.
//

import UIKit

class ReceivedRequestViewController: BaseNearUserViewController {
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("peopleData.fromQueueDBRequested", peopleData.fromQueueDBRequested)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkDataisEmpty(bool: peopleData.fromQueueDBRequested.isEmpty)
        if peopleData.fromQueueDBRequested.isEmpty { return }
        setDatasource(personData: peopleData.fromQueueDBRequested)
    }
    
    override func insideImageButtonTapped(_ sender: UIButton) {
        
    }
    
}
