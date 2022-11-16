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
    
    var gender: Int = 0
    
    let manButton: UIButton = {
        var configuration = UIButton.Configuration.tinted()
        configuration.image = UIImage(named: "man")
        configuration.imagePlacement = .top
        configuration.baseBackgroundColor = .clear
        configuration.baseForegroundColor = .black
        configuration.attributedTitle = "남자"
        configuration.attributedTitle?.font = UIFont(name: "NotoSansKR-Regular", size: 16)
        
        let button = UIButton(configuration: configuration)
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.gray3.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    let womanButton: UIButton = {
        var configuration = UIButton.Configuration.tinted()
        configuration.image = UIImage(named: "woman")
        configuration.imagePlacement = .top
        configuration.baseBackgroundColor = .clear
        configuration.baseForegroundColor = .black
        configuration.attributedTitle = "여자"
        configuration.attributedTitle?.font = UIFont(name: "NotoSansKR-Regular", size: 16)
        
        let button = UIButton(configuration: configuration)
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.gray3.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(manButton)
        stackView.addArrangedSubview(womanButton)
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    override func loadView() {
        view = genderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genderView.textField.isHidden = true
        genderView.lineView.isHidden = true
        bind()
        
    }
    
    func bind() {
        manButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.manButton.configuration?.baseBackgroundColor = .brandWhiteGreen
                vc.womanButton.configuration?.baseBackgroundColor = .clear
                vc.gender = 1
                vc.commonTapEvent()
            }.disposed(by: disposeBag)
        
        womanButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.womanButton.configuration?.baseBackgroundColor = .brandWhiteGreen
                vc.manButton.configuration?.baseBackgroundColor = .clear
                // 여자 :0 set
                vc.gender = 0
                vc.commonTapEvent()
            }.disposed(by: disposeBag)

        genderView.button.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                UserDefaults.standard.set(vc.gender, forKey: "gender")
                //POST Method Needed
                APIManager.shared.signup(idtoken: UserDefaults.standard.string(forKey: "idtoken") ?? "") { statuscode in
                    guard let statuscode else { return }
                    switch statuscode {
                    case 200:
                        vc.navigationController?.pushViewController(TabBarController(), animated: true)
                    case 201:
                        Toast.makeToast(view: vc.genderView, message: "이미 가입한 회원입니다")
                    case 202: // 유효하지 않은 닉네임
                        Toast.makeToast(view: vc.genderView, message: "유효하지않은 닉네임 입니다.")
                    case 401: // Firebase Token Error
                        TokenManager.shared.getIdToken { id in
                            UserDefaults.standard.set(id, forKey: "idtoken")
                        }
                        Toast.makeToast(view: vc.genderView, message: "다시 시도해보세요.")
                    case 500: // Server Error
                        Toast.makeToast(view: vc.genderView, message: "500 Server Error")
                    case 501: // Client Error
                        Toast.makeToast(view: vc.genderView, message: "501 Client Error")
                    default:  // Undefied Error
                        Toast.makeToast(view: vc.genderView, message: "Unidentified Error")
                    }
                    
                }
            }.disposed(by: disposeBag)
    }
    
    override func setupUI() {
        view.addSubview(stackView)
        genderView.label.attributedText = setupAttributeString()
        genderView.label.textAlignment = .center
        genderView.button.setTitle("다음", for: .normal)
    }
    
    override func makeConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(genderView.label.snp.bottom).offset(32)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.bottom.equalTo(genderView.button.snp.top).offset(-32)
        }
    }
    
    func commonTapEvent() {
        genderView.button.isEnabled = true
        genderView.button.backgroundColor = .brandGreen
        genderView.button.tintColor = .white
    }
    
    func setupAttributeString() -> NSAttributedString {
        let attrStr = attributeString(first: "성별을 선택해 주세요\n", second: "새싹 찾기 기능을 이용하기 위해서 필요해요!", firstSize: 20, secondSize: 16, firstColor: .black, secondColor: .gray7)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        attrStr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrStr.length))
        return attrStr
    }
    
}
