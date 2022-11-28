//
//  RequestPopupViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/28.
//

import UIKit

import RxCocoa
import RxSwift


class RequestPopupViewController: PopupViewController {
    var fromQueueDB: FromQueueDB!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func makeConstraints() {
        popUpView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(178)
        }
        
    }
    
    override func bind() {
        popUpView.okButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                TokenManager.shared.getIdToken { idToken in
                    QueueAPIManager.shared.myStudy(idtoken: idToken, otheruid: vc.fromQueueDB.uid) { statusCode in
                        // status code handling needed
                    }
                }
            }.disposed(by: disposebag)
        popUpView.cancelButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.dismiss(animated: true)
            }.disposed(by: disposebag)
    }
    
    
    
    
}
