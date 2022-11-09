//
//  GenderViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/09.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit

class GenderViewController: BaseViewController, AttributeString {
    let genderView = SignUpAndAuthView()
    let disposeBag = DisposeBag()
    let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "man"), for: .normal)
        button.setTitle("\n남자", for: .normal)
        button.titleLabel?.textColor = .label
        return button
    }()
    override func loadView() {
        view = genderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genderView.textField.isHidden = true
        genderView.lineView.isHidden = true
        
    }
    
    func bind() {
        genderView.button.rx.tap
            .bind { _ in
                print("gender next tapped")
            }.disposed(by: disposeBag)
    }
    
    override func setupUI() {
        view.addSubview(button)
        genderView.label.attributedText = setupAttributeString()
        genderView.label.textAlignment = .center
    }
    
    override func makeConstraints() {
        button.snp.makeConstraints { make in
            make.top.equalTo(genderView.label.snp.bottom).offset(32)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.height.equalTo(120)
            make.width.equalTo(166)
        }
    }
    func setupAttributeString() -> NSAttributedString {
        let attrStr = attributeString(first: "성별을 선택해 주세요\n", second: "새싹 찾기 기능을 이용하기 위해서 필요해요!", firstSize: 20, secondSize: 16, firstColor: .black, secondColor: .gray7)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        attrStr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrStr.length))
        return attrStr
    }
    
}
