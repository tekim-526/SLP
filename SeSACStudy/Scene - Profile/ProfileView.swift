//
//  ProfileView.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/14.
//

import UIKit

import SnapKit

class ProfileView: BaseView {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        self.addSubview(collectionView)
        collectionView.backgroundColor = .brandGreen
    }
    
    override func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .grouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
    
        return layout
       
        
    }
}
