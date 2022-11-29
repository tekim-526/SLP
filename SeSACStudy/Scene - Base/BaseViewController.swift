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
        navigationController?.navigationBar.barTintColor = .gray3
        navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    @objc func backButtonTapped() {
        self.navigationController?.popToViewController(self, animated: true)
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
