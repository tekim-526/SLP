//
//  ViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/07.
//

import UIKit

// 리뷰 : - 전체 메서드 분리 해보자 메서드 길이 길어지는 부분에 대해서 생각해보자! "MVC -> MVVM 으로 바꾸기에 편할겁니다~!"


class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        let mainVC = MainViewController()
        
        let profileVC = ProfileViewController()
        
        mainVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "Vector"), selectedImage: nil)
        profileVC.tabBarItem = UITabBarItem(title: "내정보", image: UIImage(named: "Property 1=my, Property 2=inact"), selectedImage: nil)
        mainVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "NotoSansKR-Regular", size: 12)!], for: .normal)
        profileVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "NotoSansKR-Regular", size: 12)!], for: .normal)
        
        let mainNav = UINavigationController(rootViewController: mainVC)
        let profileNav = UINavigationController(rootViewController: profileVC)
        self.tabBar.tintColor = .brandGreen
        self.tabBar.backgroundColor = .systemBackground
        viewControllers = [mainNav, profileNav/*, mapVC*/]
    }
}


