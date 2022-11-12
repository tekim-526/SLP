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
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "arrow")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "arrow")
        navigationController?.navigationBar.backIndicatorImage?.withTintColor(.gray3)
        navigationController?.navigationBar.barTintColor = .gray3
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: nil)
        
    }
    @objc func backButtonTapped() {
        self.navigationController?.popToViewController(self, animated: true)
    }
}
