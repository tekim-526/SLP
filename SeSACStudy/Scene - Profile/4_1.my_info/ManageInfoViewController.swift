//
//  ManageInfoViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/14.
//

import UIKit
import SnapKit

class ManageInfoViewController: BaseViewController {
    let manageInfoView = ManageInfoView()
    
    var datasource: UICollectionViewDiffableDataSource<Int, String>!
    var isExpanded: Bool = false
    
    override func loadView() {
        view = manageInfoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageInfoView.collectionView.delegate = self
        setDatasource()
    }
    func setDatasource() {
        
        let expandableCellRegisteration = UICollectionView.CellRegistration<ExpandableCell, String> { cell, indexPath, item in
            cell.label.text = item
        }
        let genderCellRegisteration = UICollectionView.CellRegistration<GenderCell, String> { cell, indexPath, item in
            cell.label.text = item
        }
        datasource = UICollectionViewDiffableDataSource(collectionView: manageInfoView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            if indexPath == [0, 0] {
                let cell = collectionView.dequeueConfiguredReusableCell(using: expandableCellRegisteration, for: indexPath, item: itemIdentifier)
                return cell
            } else {
                let cell = collectionView.dequeueConfiguredReusableCell(using: genderCellRegisteration, for: indexPath, item: itemIdentifier)
                return cell
            }
        })
        
                
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        
        snapshot.appendSections([0])
        snapshot.appendItems([UserDefaults.standard.string(forKey: "nick")!])
        snapshot.appendSections([1])
        snapshot.appendItems(["내 성별"])
        datasource.apply(snapshot)
    }
    
}

extension ManageInfoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath == [0, 0] {
            guard let cell = collectionView.cellForItem(at: [0, 0]) as? ExpandableCell else { return }
            switch isExpanded {
            case true:
                collectionView.setCollectionViewLayout(manageInfoView.createLayout(height: 58), animated: false)
                cell.sesacTitleLabel.isHidden = true
                cell.stackView4.isHidden = true
                cell.sesacReviewLabel.isHidden = true
                cell.sesacTextField.isHidden = true
                cell.foldButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            case false:
                collectionView.setCollectionViewLayout(manageInfoView.createLayout(height: 310), animated: false)
                cell.sesacTitleLabel.isHidden = false
                cell.stackView4.isHidden = false
                cell.sesacReviewLabel.isHidden = false
                cell.sesacTextField.isHidden = false
                cell.foldButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            }
            isExpanded.toggle()
        }
    }
    
}

