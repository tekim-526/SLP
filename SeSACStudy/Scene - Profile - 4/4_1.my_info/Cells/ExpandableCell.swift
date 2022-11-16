//
//  ExpandableCell.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/14.
//

import UIKit

import SnapKit


class ExpandableCell: BaseCollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.text = UserDefaults.standard.string(forKey: "nick")
        label.font = UIFont(name: "NotoSansKR-Medium", size: 16)
        return label
    }()
    
    let foldButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .gray7
        return button
    }()
    
    let lineView: UIView = {
        let button = UIView()
        button.layer.borderColor = UIColor.gray2.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        return button
    }()
    
    let sesacTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "새싹 타이틀"
        label.font = UIFont(name: "NotoSansKR-Regular", size: 12)
        label.isHidden = true
        return label
    }()
    
    let mannerButton = UIButton().customButtonInMyInfo(title: "좋은 매너")
    let timeButton = UIButton().customButtonInMyInfo(title: "정확한 시간 약속")
    
    let responseButton = UIButton().customButtonInMyInfo(title: "빠른 응답")
    let personalityButton = UIButton().customButtonInMyInfo(title: "친절한 성격")
    
    let skilButton = UIButton().customButtonInMyInfo(title: "능숙한 실력")
    let haveAGoodTimeButton = UIButton().customButtonInMyInfo(title: "유익한 시간")
    
    lazy var buttons: [UIButton] = [mannerButton, timeButton, responseButton, personalityButton,
    skilButton, haveAGoodTimeButton]
    
    lazy var stackView1 = UIStackView().makeStackView(axis: .horizontal, mannerButton, timeButton)
    lazy var stackView2 = UIStackView().makeStackView(axis: .horizontal, responseButton, personalityButton)
    lazy var stackView3 = UIStackView().makeStackView(axis: .horizontal, skilButton, haveAGoodTimeButton)
    lazy var stackView4 = UIStackView().makeStackView(axis: .vertical, isHidden: true, stackView1, stackView2, stackView3)
    
    let sesacReviewLabel: UILabel = {
        let label = UILabel()
        label.text = "새싹 리뷰"
        label.font = UIFont(name: "NotoSansKR-Regular", size: 12)
        label.isHidden = true
        return label
    }()
    
    let sesacTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        tf.placeholder = "첫 리뷰를 기다리는 중이에요"
        tf.isUserInteractionEnabled = false
        tf.isHidden = true
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
  
    override func setupUI() {
        [label, foldButton, lineView, sesacTitleLabel, stackView4, sesacReviewLabel, sesacTextField].forEach {self.contentView.addSubview($0)}
    }
    
    override func makeConstraints() {
        lineView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        foldButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(lineView.snp.trailing).offset(-18)
        }
        label.snp.makeConstraints { make in
            make.leading.equalTo(lineView.snp.leading).offset(16)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
        }
        sesacTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(24)
            make.leading.equalTo(lineView.snp.leading).offset(16)
        }
        stackView4.snp.makeConstraints { make in
            make.top.equalTo(sesacTitleLabel.snp.bottom).offset(16)
            make.height.equalTo(112)
            make.leading.equalTo(lineView.snp.leading).offset(16)
            make.trailing.equalTo(lineView.snp.trailing).offset(-16)
        }
        sesacReviewLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView4.snp.bottom).offset(24)
            make.leading.equalTo(lineView.snp.leading).offset(16)
        }
        sesacTextField.snp.makeConstraints { make in
            make.top.equalTo(sesacReviewLabel.snp.bottom).offset(16)
            make.leading.equalTo(lineView.snp.leading).offset(16)
            make.trailing.equalTo(lineView.snp.trailing).offset(-16)
        }
    }
    
}
