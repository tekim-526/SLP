//
//  NearUserCell.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/23.
//

import UIKit

class NearUserCell: BaseCollectionViewCell {
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "sesac_background_1")
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        image.addSubview(characterImage)
        image.addSubview(button)
        return image
    }()
    let characterImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "sesac_face_1")
        return image
    }()
    let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Property 1=propose"), for: .normal)
        return button
    }()
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
        label.isHidden = false
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
    lazy var stackView4 = UIStackView().makeStackView(axis: .vertical, isHidden: false, stackView1, stackView2, stackView3)
    
    lazy var stackView5 = UIStackView().makeStackView(axis: .vertical, isHidden: true, spacing: 16, distribution: .fillProportionally, sesacTitleLabel, stackView4, sesacReviewLabel, sesacTextField)
    
    let sesacReviewLabel: UILabel = {
        let label = UILabel()
        label.text = "새싹 리뷰"
        label.font = UIFont(name: "NotoSansKR-Regular", size: 12)
        label.isHidden = false
        return label
    }()
    
    let sesacTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        tf.placeholder = "첫 리뷰를 기다리는 중이에요"
        tf.isUserInteractionEnabled = false
        tf.isHidden = false
        return tf
    }()
    
    let clearView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
  
    override func setupUI() {
        [image, button, clearView, label, foldButton, lineView, stackView5].forEach {self.contentView.addSubview($0)}
    }
    
    override func makeConstraints() {
        image.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(194)
        }
        characterImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        button.snp.makeConstraints { make in
            make.top.equalTo(image.snp.top).offset(12)
            make.trailing.equalTo(image.snp.trailing).inset(12)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        foldButton.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.top).offset(16)
            make.trailing.equalToSuperview().inset(34)
        }

        label.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.top).offset(16)
            make.leading.equalToSuperview().inset(32)
        }
        clearView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.trailing.equalToSuperview().inset(34)
            make.height.equalTo(16)
        }
        stackView5.snp.makeConstraints { make in
            make.top.equalTo(clearView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(0)
            make.bottom.equalToSuperview()
        }
        
    }
    
}
