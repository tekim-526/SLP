//
//  BaseViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/07.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        setupUI()
        makeConstraints()
        tabBarController?.tabBar.isHidden = true
    }
    func setupUI() { }
    func makeConstraints() { }
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    func makeNavigationUI(title: String? = nil ,rightBarButtonItem: UIBarButtonItem? = nil) {
        navigationItem.title = title
        navigationItem.titleView?.tintColor = .black
        
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "arrow")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "arrow")
        navigationController?.navigationBar.backIndicatorImage?.withTintColor(.gray3)
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    @objc func backButtonTapped() {
        self.navigationController?.popToViewController(self, animated: true)
    }
    func changeSceneToMain(vc: UIViewController, isNav: Bool = true) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let vc = vc
        let nav = UINavigationController(rootViewController: vc)
        
        sceneDelegate?.window?.rootViewController = isNav ? nav : vc
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    func handleError(status: NetworkStatus) {
        switch status {
        case .notAcceptable: changeSceneToMain(vc: OnBoardingViewController())
        case .internalServerError: Toast.makeToast(view: view, message: "500 Server Error")
        case .notImplemented: Toast.makeToast(view: view, message: "501 Client Error")
        default: Toast.makeToast(view: view, message: "다시 시도 해보세요")
        }
    }
}
