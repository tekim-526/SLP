//
//  ReceivedRequestViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/23.
//

import UIKit

class AcceptViewController: BaseRequestAndAccpetViewController {
    let button: UIButton = {
       let button = UIButton()
        button.backgroundColor = .black
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        print("peopleData.fromQueueDBRequested", peopleData.fromQueueDBRequested)
        button.addTarget(self, action: #selector(insideImageButtonTapped), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        checkDataisEmpty(bool: peopleData.fromQueueDBRequested.isEmpty)
        if peopleData.fromQueueDBRequested.isEmpty { return }
        setDatasource(personData: peopleData.fromQueueDBRequested)
    }
    
    override func insideImageButtonTapped(_ sender: UIButton) {
        guard let id = UserDefaults.standard.string(forKey: UserDefaultsKey.idtoken.rawValue) else { return }
        print("sender.tag :", sender.tag)
//        let otheruid = peopleData.fromQueueDBRequested[sender.tag].uid
        QueueAPIManager.shared.myStudy(idtoken: id, method: .studyaccept, otheruid: "I8926rjKaTTzkqCE8PSXZ34YKjP2") { status in
            print("status :", status.rawValue, status.localizedDescription)
        }
        let vc = ChatViewController()
        vc.otheruid = "I8926rjKaTTzkqCE8PSXZ34YKjP2"
        present(vc, animated: true)
    }
    
}
