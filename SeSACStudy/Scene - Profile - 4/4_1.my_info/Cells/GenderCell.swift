//
//  Sample.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/15.
//

import UIKit
import SnapKit

class GenderCell: BaseCollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        return label
    }()
    
    let maleButton: UIButton = UIButton().customGenderSelectButtonInMyInfo(genderTitle: "남자")
    let femaleButton: UIButton = UIButton().customGenderSelectButtonInMyInfo(genderTitle: "여자")
    lazy var stackView: UIStackView = UIStackView().makeStackView(axis: .horizontal, maleButton, femaleButton)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        maleButton.addTarget(self, action: #selector(maleButtonTapped), for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(femaleButtonTapped), for: .touchUpInside)
    }
    override func setupUI() {
        [label, stackView].forEach { self.contentView.addSubview($0) }
    }
    override func makeConstraints() {
        label.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
        }
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(42)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.width.equalTo(120)

        }
    }
    
    @objc func maleButtonTapped() {
        maleButton.setTitleColor(.white, for: .normal)
        maleButton.backgroundColor = .brandGreen
        femaleButton.setTitleColor(.black, for: .normal)
        femaleButton.backgroundColor = .white
    }
    @objc func femaleButtonTapped() {
        femaleButton.setTitleColor(.white, for: .normal)
        femaleButton.backgroundColor = .brandGreen
        maleButton.setTitleColor(.black, for: .normal)
        maleButton.backgroundColor = .white
    }
}

