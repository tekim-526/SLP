//
//  NearUserView.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/21.
//

import UIKit

import SnapKit

class NearUserView: BaseView {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "empty_img")
        return imageView
    }()
    
    let changeButton: UIButton = {
        let button = UIButton().customButtonInMyInfo(title: "스터디 변경하기")
        button.backgroundColor = .brandGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 0
        return button
    }()
    
    let refreshButton: UIButton = {
        let button = UIButton().makeFloatingButton(title: nil, image: UIImage(named: "bt_refresh"))
        return button
    }()
    
    
    lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView().makeStackView(axis: .horizontal, isHidden: false, spacing: 4, distribution: .fillProportionally, changeButton, refreshButton)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func setupUI() {
        [collectionView, imageView, bottomStackView].forEach { self.addSubview($0) }
    }
    
    override func makeConstraints() {
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(183)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(62)
        }
        
        bottomStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(50)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        refreshButton.snp.makeConstraints { make in
            make.width.equalTo(48)
        }
    }
    
    func createLayout(height: CGFloat = 58) -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(height))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}

