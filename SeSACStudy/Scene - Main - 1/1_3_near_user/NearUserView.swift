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
            make.edges.equalTo(self.safeAreaLayoutGuide)
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

class PageView: BaseView {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func createLayout(height: CGFloat = 58) -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(height))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
