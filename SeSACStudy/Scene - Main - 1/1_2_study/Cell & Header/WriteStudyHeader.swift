//
//  WriteStudyHeader.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/17.
//

import UIKit

class WriteStudyHeader: UICollectionReusableView {
   
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NotoSansKR-Regular", size: 12)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        [label].forEach { self.addSubview($0) }
    }
    
    func makeConstraints() {
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.centerY.equalTo(self.snp.centerY)
        }
        
    }
}

