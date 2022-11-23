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
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func setupUI() {
        [collectionView].forEach { self.addSubview($0) }
    }
    override func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func createLayout(height: CGFloat = 58) -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(194))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "nearUser", alignment: .top)
        header.contentInsets = .init(top: -32, leading: 0, bottom: 16, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}
