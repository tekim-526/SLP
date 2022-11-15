//
//  ManageInfoView.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/14.
//

import UIKit

import SnapKit

enum Section: Int, CaseIterable {
  case top
  case bottom
  var columnCount: Int {
    switch self {
    case .top:
      return 0
    case .bottom:
      return 1
    }
  }
}

class ManageInfoView: BaseView {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sesac_background_1")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout(height: 58))
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func setupUI() {
        [imageView, collectionView].forEach { self.addSubview($0) }
//        collectionView.backgroundColor = .systemMint
    }
    
    override func makeConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(194)
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
            guard let sectionType = Section(rawValue: sectionIndex) else {
                  return nil
            }
            let sectionNum = sectionType.rawValue
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupHeight = sectionIndex == 0 ? NSCollectionLayoutDimension.absolute(height) : NSCollectionLayoutDimension.absolute(58)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)

            return section
          }
        
        
        return layout
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                              heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupHeight = section == 0 ? NSCollectionLayoutDimension.absolute(310) : NSCollectionLayoutDimension.absolute(58)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//
//        let section = NSCollectionLayoutSection(group: group)
//
//        let layout = UICollectionViewCompositionalLayout(section: section)
            
    }
    
    

}
