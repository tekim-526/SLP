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
                guard let idtoken = UserDefaults.standard.string(forKey: UserDefaultsKey.idtoken.rawValue) else { return }
                QueueAPIManager.shared.myStudy(idtoken: idtoken, otheruid: vc.fromQueueDB.uid) { [weak self] statusCode in
                    switch statusCode {
                    case .ok: vc.dismiss(animated: true)
                    case .created: Toast.makeToast(view: vc.view, message: "상대방이 이미 다른 새싹과 스터디를 함께 하는 중입니다")
                    case .accepted: Toast.makeToast(view: vc.view, message: "상대방이 스터디 찾기를 그만두었습니다")
                    case .nonAuthoritativeInformation:
                        Toast.makeToast(view: vc.view, message: "앗! 누군가가 나의 스터디를 수락하였어요")
                        vc.myStateCheck()
                    case .unauthorized:
                        TokenManager.shared.getIdToken { [weak self] id in
                            UserDefaults.standard.set(id, forKey: UserDefaultsKey.idtoken.rawValue)
                            Toast.makeToast(view: self?.view, message: "다시 시도 해주세요")
                        }
                    case .notAcceptable: vc.changeSceneToMain(vc: OnBoardingViewController())
                    case .internalServerError: Toast.makeToast(view: vc.view, message: "500 Server Error")
                    case .notImplemented: Toast.makeToast(view: vc.view, message: "501 Client Error")
                    default: Toast.makeToast(view: vc.view, message: statusCode.localizedDescription)
                    }
                }
            }.disposed(by: disposebag)
        
        popUpView.cancelButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.dismiss(animated: true)
            }.disposed(by: disposebag)
    }
    
    func myStateCheck() {
        QueueAPIManager.shared.myQueueState { [weak self] response in
            switch response {
            case .success(let data):
                if data.matched == 1 {
                    Toast.makeToast(view: self?.view, message: "\(data.matchedNick)님과 매칭되셨습니다.")
                }
            case .failure(let status):
                switch status {
                case .unauthorized: TokenManager.shared.getIdToken { _ in self?.myStateCheck()}
                case .notAcceptable: self?.changeSceneToMain(vc: OnBoardingViewController())
                case .internalServerError: Toast.makeToast(view: self?.view, message: "500 Server Error")
                case .notImplemented: Toast.makeToast(view: self?.view, message: "501 Client Error")
                default: Toast.makeToast(view: self?.view, message: status.localizedDescription)
                }
            }
        }
    }
}

