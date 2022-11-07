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
    func makeNavigationUI(title: String ,rightBarButtonItem: UIBarButtonItem?) {
        navigationItem.title = title
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationController?.navigationBar.tintColor = .white
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = .mainColor
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
    }
}
