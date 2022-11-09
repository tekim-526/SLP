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
    }
    @objc func startButtonTapped() {
        print("start")
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
