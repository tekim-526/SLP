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
        let studyCellRegisteration = UICollectionView.CellRegistration<StudyCell, String> { cell, indexPath, item in
            cell.label.text = item
        }
        let phoneNumberPermitCellRegisteration = UICollectionView.CellRegistration<PhoneNumberPermitCell, String> { cell, indexPath, item in
            cell.label.text = item
        }
        let ageCellRegisteration = UICollectionView.CellRegistration<AgeCell, String> { cell, indexPath, item in
            cell.label.text = item
        }
        datasource = UICollectionViewDiffableDataSource(collectionView: manageInfoView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            if indexPath.section == 0 {
                let cell = collectionView.dequeueConfiguredReusableCell(using: expandableCellRegisteration, for: indexPath, item: itemIdentifier)
                return cell
            } else if indexPath.section == 1 {
                let cell = collectionView.dequeueConfiguredReusableCell(using: genderCellRegisteration, for: indexPath, item: itemIdentifier)
                return cell
            } else if indexPath.section == 2 {
                let cell = collectionView.dequeueConfiguredReusableCell(using: studyCellRegisteration, for: indexPath, item: itemIdentifier)
                return cell
            } else if indexPath.section == 3 {
                let cell = collectionView.dequeueConfiguredReusableCell(using: phoneNumberPermitCellRegisteration, for: indexPath, item: itemIdentifier)
                return cell
            } else if indexPath.section == 4{
                let cell = collectionView.dequeueConfiguredReusableCell(using: ageCellRegisteration, for: indexPath, item: itemIdentifier)
                return cell
            } else {
                let cell = collectionView.dequeueConfiguredReusableCell(using: genderCellRegisteration, for: indexPath, item: itemIdentifier)
                cell.stackView.isHidden = true
                return cell
            }
        })
        
                
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        
        snapshot.appendSections([0, 1, 2, 3, 4, 5])
        snapshot.appendItems([UserDefaults.standard.string(forKey: "nick")!], toSection: 0)
        snapshot.appendItems(["내 성별"], toSection: 1)
        snapshot.appendItems(["자주하는 스터디"], toSection: 2)
        snapshot.appendItems(["내 번호 검색 허용"], toSection: 3)
        snapshot.appendItems(["상대방 연령대"], toSection: 4)
        snapshot.appendItems(["회원탈퇴"], toSection: 5)
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
        print(indexPath)
    }
    
}

