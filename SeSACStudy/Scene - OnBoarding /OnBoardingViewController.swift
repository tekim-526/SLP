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
    }
    
    override func setupUI() {
        customPageVC = CustomPageViewController()
        onboardingView.addSubview(customPageVC.view)
    }
    
    override func makeConstraints() {
        customPageVC.view.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
