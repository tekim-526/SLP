//
//  ManageInfoView.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/14.
//

import UIKit

import SnapKit


class ManageInfoView: BaseView {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "sesac_background_1")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    let sesacImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sesac_face_1")
        return imageView
    }()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout(height: 58))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func setupUI() {
        [imageView, collectionView, sesacImageView].forEach { self.addSubview($0) }
    }
    
    override func makeConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(194)
        }
        sesacImageView.snp.makeConstraints { make in
            make.centerX.equalTo(imageView.snp.centerX)
            make.centerY.equalTo(imageView.snp.centerY)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(self.safeAreaLayoutGuide)
            make.trailing.equalTo(self.safeAreaLayoutGuide)
        }
        
    }
    func createLayout(height: CGFloat) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
           
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupHeight = sectionIndex == 0 ? NSCollectionLayoutDimension.absolute(height) : sectionIndex == 4 ? NSCollectionLayoutDimension.absolute(80) : NSCollectionLayoutDimension.absolute(58)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)

            return section
          }
        return layout

    }
    
    

}
