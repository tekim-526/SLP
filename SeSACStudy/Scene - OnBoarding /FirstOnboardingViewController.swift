//
//  FirstOnboardingViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/07.
//

import UIKit
import SnapKit

class FirstOnboardingViewController: BaseViewController {
    let first = FirstOnboardingView()
    
    override func loadView() {
        view = first
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class FirstOnboardingView: BaseView {
    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2

        let attributedTitle = NSMutableAttributedString(string: "위치기반", attributes: [NSAttributedString.Key.foregroundColor : UIColor.brandGreen, NSAttributedString.Key.font: UIFont(name: "NotoSansKR-Medium", size: 24)!])
        
        attributedTitle.append(NSAttributedString(string: "으로 빠르게 주위 친구를 확인", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont(name: "NotoSansKR-Regular", size: 24)!]))
        label.attributedText = attributedTitle
        return label
    }()
    
    let image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "onboarding_img1")
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        self.addSubview(label)
        self.addSubview(image)
    }
    
    override func makeConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(116)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(85)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-85)
        }
        image.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(56)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-8)
        }
    }
}
