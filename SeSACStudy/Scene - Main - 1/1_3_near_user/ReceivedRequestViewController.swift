//
//  ReceivedRequestViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/23.
//

import UIKit

class ReceivedRequestViewController: NearUserViewController {
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    
    override func setDatasource() {
        let cellReg = UICollectionView.CellRegistration<NearUserCell, String> { cell, indexPath, itemIdentifier in
            
        }
        datasource = UICollectionViewDiffableDataSource(collectionView: nearUserView.collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellReg, for: indexPath, item: itemIdentifier)
            cell.button.setImage(UIImage(named: "Property 1=accept"), for: .normal)
            cell.button.addTarget(self, action: #selector(self?.acceptButtonTapped), for: .touchUpInside)
            return cell
        }
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(["태수킴"])
        datasource.apply(snapshot)
    }
    @objc func acceptButtonTapped() {
        print("Accept Tapped!")
    }
}
