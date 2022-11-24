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
        let cellReg = UICollectionView.CellRegistration<NearUserCell, UserInfoModel> { cell, indexPath, itemIdentifier in
            
        }
        datasource = UICollectionViewDiffableDataSource(collectionView: nearUserView.collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellReg, for: indexPath, item: itemIdentifier)
            cell.button.setImage(UIImage(named: "Property 1=accept"), for: .normal)
            cell.button.addTarget(self, action: #selector(self?.acceptButtonTapped), for: .touchUpInside)
            return cell
        }
        var snapshot = NSDiffableDataSourceSnapshot<Int, UserInfoModel>()
        snapshot.appendSections([0])
//        snapshot.appendItems([UserInfoModel(background: <#T##Int#>, reviews: <#T##[String]#>, nick: <#T##String#>, uid: <#T##String#>, studylist: <#T##[String]#>, sesac: <#T##Int#>, gender: <#T##Int#>)])
        datasource.apply(snapshot)
    }
    @objc func acceptButtonTapped() {
        print("Accept Tapped!")
    }
}
