//
//  WithdrawPopUpViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/16.
//

import UIKit
import SnapKit

protocol SendOpacityProtocol {
    func sendOpacityAndColor(opacity: CGFloat)
}

class WithdrawPopUpViewController: BaseViewController {
    let popUpView = WithdrawPopUpView()
    var delegate: SendOpacityProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        popUpView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
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
    @objc func okButtonTapped() {
        guard let idtoken = UserDefaults.standard.string(forKey: "idtoken") else {
            //못지우는 토스트
            return
        }
        UserAPIManager.shared.withdraw(idtoken: idtoken) {
            UserDefaults.standard.set(false, forKey: "OnboardingStartButtonTapped")
            self.changeSceneToMain(vc: OnBoardingViewController())
        }
        // onboarding으로 이동하는 메서드 및 유저디폴트 초기화
    }
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    func changeSceneToMain(vc: UIViewController) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let vc = vc
        let nav = UINavigationController(rootViewController: vc)
        
        sceneDelegate?.window?.rootViewController = nav
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}
