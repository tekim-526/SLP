//
//  NearRequestViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/23.
//

import UIKit

class NearRequsetViewController: BaseViewController {
    var peopleData: GetNearPeopleData!
    
    private let segmentedControl: UISegmentedControl = {
        let seg = UnderlineSegmentedControl(items: ["주변 새싹", "받은 요청"])
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray2, NSAttributedString.Key.font: UIFont(name: "NotoSansKR-Regular", size: 14)!], for: .normal)
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.brandGreen, NSAttributedString.Key.font: UIFont(name: "NotoSansKR-Regular", size: 14)!], for: .selected)
        seg.selectedSegmentIndex = 0
        return seg
    }()
    
    private lazy var vc1: NearUserViewController = {
        let vc = NearUserViewController()
        vc.isRequest = false
        vc.peopleData = peopleData
        return vc
    }()
    
    private lazy var vc2: ReceivedRequestViewController = {
        let vc = ReceivedRequestViewController()
        vc.isRequest = true
        vc.peopleData = peopleData
        return vc
    }()
    

    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        vc.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
        vc.delegate = self
        vc.dataSource = self
        return vc
    }()
    
    
    
    var dataViewControllers: [UIViewController] {
        [self.vc1, self.vc2]
    }
    
    var currentPage: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            self.pageViewController.setViewControllers([dataViewControllers[self.currentPage]], direction: direction, animated: true, completion: nil)
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .systemBackground
        self.segmentedControl.selectedSegmentIndex = 0
        self.segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        self.changeValue(control: self.segmentedControl)


    }
    override func setupUI() {
        view.addSubview(segmentedControl)
        view.addSubview(pageViewController.view)
    }
    
    override func makeConstraints() {
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        

    }
    @objc private func changeValue(control: UISegmentedControl) {
        self.currentPage = control.selectedSegmentIndex
      }
    

}

extension NearRequsetViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard
            let index = self.dataViewControllers.firstIndex(of: viewController),
            index - 1 >= 0
        else { return nil }
        return self.dataViewControllers[index - 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard
            let index = self.dataViewControllers.firstIndex(of: viewController),
            index + 1 < self.dataViewControllers.count
        else { return nil }
        return self.dataViewControllers[index + 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers iousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard
            let viewController = pageViewController.viewControllers?[0],
            let index = self.dataViewControllers.firstIndex(of: viewController)
        else { return }
        self.currentPage = index
        self.segmentedControl.selectedSegmentIndex = index
    }
}
