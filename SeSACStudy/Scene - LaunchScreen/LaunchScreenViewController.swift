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
        guard let id = UserDefaults.standard.string(forKey: "idtoken") else { return }
        UserAPIManager.shared.login(idtoken: id) { [weak self] result in
            
            switch result {
            case .success(let data):
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                let vc = TabBarController()
//                let vc = RequestAndAcceptViewController()
//                let nav = UINavigationController(rootViewController: vc)
                sceneDelegate?.window?.rootViewController = vc
                sceneDelegate?.window?.makeKeyAndVisible()
            case .failure(let error):
                switch error {
                case .unauthorized:
                    TokenManager.shared.getIdToken { id in
                        UserDefaults.standard.set(id, forKey: "idtoken")
                        self?.viewDidLoad()
                    }
                case .notAcceptable:
                    self?.changeSceneToMain(vc: PhoneNumberValidViewController())
                case .internalServerError:
                    Toast.makeToast(view: self?.view, message: "500 Server Error")
                case .notImplemented:
                    Toast.makeToast(view: self?.view, message: "501 Client Error")
                default:
                    Toast.makeToast(view: self?.view, message: "\(error.localizedDescription)")
                }
            }
        }
    }
    
    
}
    

