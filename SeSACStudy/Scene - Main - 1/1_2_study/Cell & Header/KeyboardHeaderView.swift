//
//  KeyboardHeaderView.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/21.
//

import UIKit
import SnapKit

class KeyboardHeaderView: BaseView {
    
    let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .brandGreen
        let attrStr = NSAttributedString(string: "새싹 찾기", attributes: [NSAttributedString.Key.font : UIFont(name: "NotoSansKR-Regular", size: 14)!, NSAttributedString.Key.foregroundColor : UIColor.white])
        button.setAttributedTitle(attrStr, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .brandGreen

    }
    
    override func setupUI() {
        self.addSubview(button)
    }
    
    override func makeConstraints() {
        button.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
}
