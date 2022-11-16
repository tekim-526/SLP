//
//  StudyCell.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/15.
//

import UIKit
import SnapKit

class StudyCell: BaseCollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        return label
    }()
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray3
        return view
    }()
    let textField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        tf.placeholder = "스터디를 입력해 주세요"
        return tf
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func setupUI() {
        [label, textField, lineView].forEach { self.contentView.addSubview($0) }
    }
    override func makeConstraints() {
        label.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
        }
        textField.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.safeAreaLayoutGuide)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.width.equalTo(148)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.width.equalTo(164)
            make.height.equalTo(1)
        }
    }
}
