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
    
    let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .gray7
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
  
    override func setupUI() {
        [label, button].forEach {self.addSubview($0)}
    }
}
