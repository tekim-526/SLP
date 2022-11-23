//
//  LaunchScreenViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/16.
//

import UIKit

class LaunchScreenViewController: BaseViewController {
    let launchScreenView = LaunchScreenView()
    
    override func loadView() {
        view = launchScreenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserDefaults.standard.bool(forKey: "OnboardingStartButtonTapped") {
            changeSceneToMain(vc: OnBoardingViewController())
        }
        // 네트워크 통신
        UserAPIManager.shared.login(idtoken: UserDefaults.standard.string(forKey: "idtoken") ?? "") { [weak self] data, success, error in
            if success { // 로그인 성공
                print("login success", success)
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                let vc = TabBarController()
//                let vc = NearRequsetViewController()
                sceneDelegate?.window?.rootViewController = vc
                sceneDelegate?.window?.makeKeyAndVisible()
                
            } else {
                switch error?.responseCode {
                case 401: // Firebase Token Error
                    TokenManager.shared.getIdToken { id in
                        UserDefaults.standard.set(id, forKey: "idtoken")
                        self?.viewDidLoad()
                    }
                case 406: // 미가입 회원
                    // 회원가입 로직
                    self?.changeSceneToMain(vc: PhoneNumberValidViewController())
                case 500: // Server Error
                    Toast.makeToast(view: self?.view, message: "500 Server Error")
                case 501: // Client Error
                    Toast.makeToast(view: self?.view, message: "501 Client Error")
                default:  // Undefied Error
                    Toast.makeToast(view: self?.view, message: "Unidentified Error")
                }
            }
        }
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
    

