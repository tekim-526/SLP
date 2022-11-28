//
//  WithdrawPopUpViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/16.
//

import UIKit

import SnapKit

import RxSwift
import RxCocoa

protocol SendOpacityProtocol {
    func sendOpacityAndColor(opacity: CGFloat)
}

class PopupViewController: BaseViewController {
    let popUpView = PopupView()
    var delegate: SendOpacityProtocol!
    var disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.delegate.sendOpacityAndColor(opacity: 1)
    }
    override func setupUI() {
        view.addSubview(popUpView)
        
    }
    override func makeConstraints() {
        popUpView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(view.snp.height).multipliedBy(0.1926)
        }
    }
    
    
    func bind() {
        popUpView.okButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                guard let idtoken = UserDefaults.standard.string(forKey: UserDefaultsKey.idtoken.rawValue) else { return }
                UserAPIManager.shared.withdraw(idtoken: idtoken) { [weak self] status in
                    switch status {
                    case .ok, .notAcceptable:
                        UserDefaults.standard.set(false, forKey: UserDefaultsKey.OnboardingStartButtonTapped.rawValue)
                        self?.changeSceneToMain(vc: OnBoardingViewController())
                    case .unauthorized:
                        TokenManager.shared.getIdToken { id in
                            UserDefaults.standard.set(id, forKey: UserDefaultsKey.idtoken.rawValue)
                        }
                    case .internalServerError: Toast.makeToast(view: self?.view, message: "500 Server Error")
                    case .notImplemented: Toast.makeToast(view: self?.view, message: "501 Client Error")
                    default: Toast.makeToast(view: self?.view, message: "\(status.localizedDescription)")
                        
                    }
                }
            }.disposed(by: disposebag)
        
        popUpView.cancelButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.dismiss(animated: true)
            }.disposed(by: disposebag)
    }
   
    deinit {
        print("popupvc deinit")
    }
}
