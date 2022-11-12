//
//  OnBoardingViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/07.
//

import UIKit


class OnBoardingViewController: BaseViewController {
    
    let onboardingView = OnboardingView()
    
    var customPageVC: CustomPageViewController!
    override func loadView() {
        view = onboardingView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(customPageVC)
        customPageVC.didMove(toParent: self)
        onboardingView.startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        UserDefaults.standard.set(false, forKey: "OnboardingStartButtonTapped")
        
    }
    @objc func startButtonTapped() {
        let phoneNumberVC = PhoneNumberValidViewController()
        UserDefaults.standard.set(true, forKey: "OnboardingStartButtonTapped")
        self.navigationController?.pushViewController(phoneNumberVC, animated: true)
    }
    override func setupUI() {
        customPageVC = CustomPageViewController()
        onboardingView.addSubview(customPageVC.view)
        onboardingView.addSubview(onboardingView.startButton)
    }
    
    override func makeConstraints() {
        customPageVC.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(onboardingView.startButton.snp.top).offset(-40)
        }
    }
}
