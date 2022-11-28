//
//  AuthNumberViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import FirebaseMessaging

class AuthNumberViewController: BaseViewController {
    let authView = SignUpAndAuthView()
    
    let disposeBag = DisposeBag()
    
    let nickNameVC = NicknameViewController()
    let resendButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .brandGreen
        button.setTitle("재전송", for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func loadView() {
        view = authView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authView.textField.delegate = self
        bind()
    }
    func bind() {
        authView.textField.rx.text
            .orEmpty
            .map { $0.count == 6 }
            .withUnretained(self)
            .bind { vc, bool in
                vc.authView.button.backgroundColor = bool ? .brandGreen : .gray6
                vc.authView.button.tintColor = bool ? .white : .gray3
                vc.authView.button.isEnabled = bool
            }
            .disposed(by: disposeBag)
        resendButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                guard let phoneNumber = UserDefaults.standard.string(forKey: UserDefaultsKey.phoneNumber.rawValue) else { return }
            
                AuthManager.shared.startAuth(phoneNumber: phoneNumber) { success in
                    guard success else { return }
                        
                }
            }.disposed(by: disposeBag)
        authView.button.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                // tapEvent
                // 회원아닐 때 -> 회원가입
                TokenManager.shared.getIdToken { id in
                    UserDefaults.standard.set(id, forKey: "idtoken")
                }
                
                TokenManager.shared.getFCMToken { fcm in
                    UserDefaults.standard.set(fcm, forKey: "FCMtoken")
                }
                
                UserAPIManager.shared.login(idtoken: UserDefaults.standard.string(forKey: "idtoken") ?? "") { result in
                    switch result {
                    case .success(_):
                        vc.verifySMS()
                        print("login success")
                    case .failure(let error):
                        switch error {
                        case .unauthorized: // Firebase Token Error
                            TokenManager.shared.getIdToken { id in
                                UserDefaults.standard.set(id, forKey: "idtoken")
                                vc.verifySMS()
                            }
                        case .notAcceptable: // 미가입 회원
                            // 회원가입 로직
                            AuthManager.shared.verifySMS(sms: vc.authView.textField.text!) { success in
                                guard success else { return }
                                DispatchQueue.main.async {
                                    vc.navigationController?.pushViewController(vc.nickNameVC, animated: true)
                                }
                            }
                        case .internalServerError: // Server Error
                            Toast.makeToast(view: vc.authView, message: "500 Server Error")
                        case .notImplemented: // Client Error
                            Toast.makeToast(view: vc.authView, message: "501 Client Error")
                        default:  // Undefied Error
                            Toast.makeToast(view: vc.authView, message: error.localizedDescription)
                        }
                        
                    }
                    
                }
                // 회원 아닐때 -> 홈 화면
            }.disposed(by: disposeBag)
        
    }
    override func setupUI() {
        view.addSubview(resendButton)
        authView.label.text = "인증번호가 문자로 전송되었어요"
        authView.textField.placeholder = "인증번호 입력"
        authView.button.setTitle("인증하고 시작하기", for: .normal)
    }
 
    override func makeConstraints() {
        resendButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.centerY.equalTo(authView.textField.snp.centerY)
            make.width.equalTo(72)
            make.height.equalTo(40)
        }
        authView.lineView.snp.remakeConstraints { make in
            make.top.equalTo(authView.textField.snp.bottom)
            make.height.equalTo(1)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-96)
        }
    }
    
    func verifySMS() {
        AuthManager.shared.verifySMS(sms: self.authView.textField.text!) { success in
            guard success else { return }
            DispatchQueue.main.async {
                self.changeSceneToMain()
            }
        }
    }
    
    func changeSceneToMain() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let vc = TabBarController()
        let nav = UINavigationController(rootViewController: vc)
        
        sceneDelegate?.window?.rootViewController = nav
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
}

extension AuthNumberViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty || string >= "0" && string <= "9" {
            let newLength = (textField.text?.count)! + string.count - range.length
            return !(newLength > 6)
        } else {
            return false
        }
    }
}
