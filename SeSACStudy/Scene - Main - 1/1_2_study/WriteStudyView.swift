//
//  WriteStudyView.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/17.
//

import UIKit
import SnapKit

class WriteStudyView: BaseView {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    let button: UIButton = {
        let button = UIButton().customButtonInMyInfo(title: "새싹 찾기")
        button.backgroundColor = .brandGreen
        button.layer.borderColor = UIColor.clear.cgColor
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func setupUI() {
        self.addSubview(collectionView)
        self.addSubview(button)
    }
    override func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        button.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(55)
            make.height.equalTo(48)
        }
    }
    func createLayout() -> UICollectionViewLayout {
        let itemInset: CGFloat = 8

        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(148), heightDimension: .absolute(36))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.edgeSpacing = .init(leading: .fixed(itemInset), top: .fixed(itemInset), trailing: .fixed(itemInset), bottom: .fixed(itemInset))

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        group.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(60.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
    
        section.boundarySupplementaryItems = [header]
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
