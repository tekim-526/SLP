//
//  ManageInfoViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/14.
//

import UIKit

class ManageInfoViewController: BaseViewController {
    let manageInfoView = ManageInfoView()
    var datasource: UICollectionViewDiffableDataSource<Int, String>!
    
    override func loadView() {
        view = manageInfoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatasource()
    }
    
    func setDatasource() {
        let cellRegisteration = UICollectionView.CellRegistration<ProfileViewCell, String> { cell, indexPath, item in
            cell.label.text = item
        }
        datasource = UICollectionViewDiffableDataSource(collectionView: manageInfoView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        let header = UICollectionView.SupplementaryRegistration<ManageHeaderView>(elementKind: "header") { supplementaryView, elementKind, indexPath in
            supplementaryView.imageView.clipsToBounds = true
            supplementaryView.imageView.layer.cornerRadius = 8
        }
        
        datasource.supplementaryViewProvider = .some({ collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: header, for: indexPath)
        })
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        
        snapshot.appendItems([UserDefaults.standard.string(forKey: "nick")!, "asd", "zxc"])
        datasource.apply(snapshot, animatingDifferences: true)
    }
}
