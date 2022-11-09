//
//  CustomPageViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/07.
//

import UIKit

import SnapKit

// example Page View Controller
class CustomPageViewController: BaseViewController, AttributeString {
   
    

    var pages: [UIViewController] = [UIViewController]()
    
    let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)

    private let pageControl = UIPageControl()
    
    var currentIndex = 0 {                  // currentIndex가 변할때마다 pageControll.currentPage 값을 변경
        didSet{
            pageControl.currentPage = currentIndex
            print(currentIndex)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeOnboardingVC()
//        pages = [FirstOnboardingViewController(), FirstOnboardingViewController(), FirstOnboardingViewController()]
        pageVC.dataSource = self
        pageVC.delegate = self
        
        pageVC.setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
        setPageControl()
        
    }
    override func setupUI() {
        view.addSubview(pageVC.view)
    }
    
    func setPageControl() {
        view.addSubview(pageControl)

        pageControl.pageIndicatorTintColor = .gray5
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = currentIndex
        pageControl.addTarget(self, action: #selector(pageControlTapped), for: .touchUpInside)

        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(pageVC.view.snp.bottom)
            make.centerX.equalTo(pageVC.view.snp.centerX)
        }
    }
    
    func makeOnboardingVC() {
        
        let vc1 = FirstOnboardingViewController()
        vc1.onboardingView.image.image = UIImage(named: "onboarding_img1")
        vc1.onboardingView.label.attributedText = attributeString(first: "위치기반", second: "으로 빠르게\n주위 친구를 확인")
        pages.append(vc1)
        
        let vc2 = FirstOnboardingViewController()
        vc2.onboardingView.image.image = UIImage(named: "onboarding_img2")
        vc2.onboardingView.label.attributedText = attributeString(first: "스터디를 원하는 친구", second: "를\n찾을 수 있어요")
        pages.append(vc2)
        
        let vc3 = FirstOnboardingViewController()
        vc3.onboardingView.image.image = UIImage(named: "onboarding_img3")
        vc3.onboardingView.label.attributedText = attributeString(first: "", second: "SeSACStudy")
        pages.append(vc3)
    }
    

    
    @objc func pageControlTapped(sender: UIPageControl) {
        pageVC.setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
    }
}

// typical Page View Controller Data Source
extension CustomPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let currentIndex = pages.firstIndex(of: viewController) else {
                return nil
            }
            
            self.currentIndex = currentIndex
            
            if currentIndex == 0 {
                return pages.last
            }
            
            return pages[currentIndex - 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let currentIndex = pages.firstIndex(of: viewController) else {
                return nil
            }
            
            self.currentIndex = currentIndex
            
            if currentIndex == pages.count - 1 {
                return pages.first
            }
                
            return pages[currentIndex + 1]
        }
    
}

// typical Page View Controller Delegate
extension CustomPageViewController: UIPageViewControllerDelegate {

    // if you do NOT want the built-in PageControl (the "dots"), comment-out these funcs

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {

        guard let firstVC = pageViewController.viewControllers?.first else {
            return 0
        }
        guard let firstVCIndex = pages.firstIndex(of: firstVC) else {
            return 0
        }

        return firstVCIndex
    }
    
    
        
}
